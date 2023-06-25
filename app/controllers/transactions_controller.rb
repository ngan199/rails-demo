class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_transaction, only: %i[edit show destroy update]
  before_action :prepare_create, only: :create

  def index
    @transaction = current_user.transactions.order(created_at: :desc)
  end

  def new
    @transaction = Transaction.new
    TransactionsHelper::ExpenseNames.map do |name|
      @transaction.expenses.build(name: name)
    end
  end

  def edit; end

  def create
    if @transaction.save
      flash[:notice] = 'Transaction was successfully created'
      redirect_to transactions_path
    else
      flash[:notice] = @transaction.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    if @transaction.update(transaction_params)
      flash[:notice] = 'Transaction updated'
      redirect_to transactions_path
    else
      flash[:alert] = 'Failed to edit transaction'
      render :edit
    end
  end

  def destroy
    if @transaction.update(display: false)
      flash[:notice] = 'Transaction deleted'
    else
      flash[:alert] = @transaction.errors
    end

    redirect_to transactions_path
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(
      :total, 'year(1i)', 'year(2i)', 'year(3i)',
      expenses_attributes: %i[name amount file_upload]
    )
  end

  def prepare_create
    @transaction = Transaction.new(
      transaction_params.merge(
        user_id: current_user.id,
        year: params[:transaction]['year(1i)'],
        month: params[:transaction]['year(2i)'],
        total: total_amount(params[:transaction])
      )
    )
  end

  def total_amount(transaction)
    return 0 if transaction[:expenses_attributes].blank?

    values_array = transaction[:expenses_attributes].values.flatten
    numbers_array = values_array.pluck(:amount).map(&:to_f)
    numbers_array.compact.sum
  end
end