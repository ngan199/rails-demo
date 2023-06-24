class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_transaction, only: %i[edit show destroy update]

  def index
    @transaction = current_user.transactions.order(created_at: :desc)
    puts "transactiontransaction #{@transaction.inspect}"
  end

  def new
    @transaction = Transaction.new
    # @transaction.expenses.build
    TransactionsHelper::ExpenseNames.map do |name| 
      @transaction.expenses.build(name: name)
    end
  end

  def edit; end

  def create
    puts "transaction_params #{@transaction_params}"
    puts "paramsssss #{params}"
    Rails.logger.debug(@transaction_params)
    @transaction = Transaction.new(
      transaction_params.merge(user_id: current_user.id)
    )
    
    if @transaction.save
      puts "transaction #{@transaction.expenses.inspect}"
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
    params.require(:transaction).permit(:total, expenses_attributes: %i[name amount file_upload])
  end
end