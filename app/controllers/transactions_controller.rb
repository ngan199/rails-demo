class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_transaction, only: %i[edit show destroy update]

  def index
    year = params[:search].blank? ? Date.today.year : params[:search]['year(1i)']
    month = params[:search].blank? ? Date.today.month : params[:search]['year(2i)']
    @transactions = current_user.transactions.where(year: year, month: month, deleted: false).order(created_at: :desc)
  end

  def new
    @transaction = Transaction.new
  end

  def show
    @transaction = current_user.transactions.order(created_at: :desc).find_by(year: year, month: month, deleted: false)
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
end