class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_transaction, only: %i[edit show destroy update]

  def index
    @transaction = current_user.transactions.where(deleted: false).order(created_at: :desc)
  end

  def new
    @transaction = Transaction.new
  end

  def show
    @transaction = current_user.transactions.where(deleted: false).order(created_at: :desc)
  end

  def edit; end

  def create
    begin
      message = 'Transaction existed'

      transaction = Transaction.find_or_create_by(
        user_id: current_user.id,
        deleted: false,
        year: params[:date]['year'],
        month: params[:date]['month']
      ) do |tr| 
        message = 'Transaction was successfully created'
      end
  
      flash[:notice] = message 

      redirect_to transaction_expenses_path(transaction)
    rescue Exception => e
      flash[:notice] = e.message
      render :new
    end
  end

  def update; end

  def destroy
    if @transaction.update(deleted: true) 
      expenses = @transaction.expenses
      expenses.each do |e|
        e.update(deleted: true)
      end
      flash[:notice] = 'Transaction deleted'
    else  
      flash[:alert] = @transaction.errors
    end

    puts "@transaction@transaction #{@transaction.inspect()}"
    respond_to do |format|
      format.html { redirect_to transactions_path, notice: "Deleted transaction" }
    end
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.require(:date).permit(true)
  end

  def total_amount(transaction)
    return 0 if transaction[:expenses_attributes].blank?

    values_array = transaction[:expenses_attributes].values.flatten
    numbers_array = values_array.pluck(:amount).map(&:to_f)
    numbers_array.compact.sum
  end
end