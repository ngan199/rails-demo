class TransactionsController < ApplicationController
  # before_action :get_expense 
  # before_action :set_transaction, only [:show, :edit, :update, :destroy]

  def index 
    @transaction = Transaction.all
  end 

  def new
    @transaction = Transaction.new
    @transaction.expenses.build
  end

  def create
    @transaction = Transaction.new(transaction_params)
    if @transaction.save 
      flash[:notice] = 'Transaction added'
    else  
      flash[:notice] = "Failed to add transaction"
      render :new
    end
  end

  def edit
    @transaction = Transaction.find(params[:format])
  end

  def update
    @transaction = Transaction.find(params[:format])
    if @transaction.update_attributes_(transaction_params)
      flash[:notice] = 'Transaction updated'
      redirect_to transactions_index_path
    else  
      flash[:notice] = 'Failed to edit transaction'
      render :edit 
    end 
  end

  def destroy
    @transaction = Transaction.find(params[:format])
    if @transaction.update(display: false)
      flash[:notice] = 'Transaction deleted'
      redirect_to transactions_index_path
    else 
      flash[:notice] = 'Failed to delete expense'
      render :destroy 
    end
    # if @transaction.delete 
    #   flash[:notice] = 'Transaction deleted'
    #   redirect_to transactions_index_path
    # else 
    #   flash[:notice] = 'Failed to delete expense'
    #   render :destroy 
    # end
  end

  private
  def transaction_params 
    params.require(:transaction).permit(:total, :expenses_attributes => [:name, :amount, :file_upload])
  end
end
