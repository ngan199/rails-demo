class ExpensesController < ApplicationController
  # before_action :get_transaction

  def index 
    @expenses = Expense.all
  end 

  def show
    @expense = Expense.find(params[:format])
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)
    if @expense.save
      flash[:notice] = 'Expense added'
      redirect_to expenses_index_path
    else 
      flash[:notice] = "Failed to edit expense"
      render :new 
    end 
  end

  def edit
    @expense = Expense.find(params[:format])
  end

  def update
    @expense = Expense.find(params[:format])
    if @expense.update_attributes_(expense_params)
      flash[:notice] = 'Expense updaated'
      redirect_to root_path 
    else  
      flash[:errors] = 'Failed to edit expense'
      render :edit  
    end 
  end

  def destroy
    @expense = Expense.find(params[:format])
    if @expense.delete
      flash[:notice] = 'Expense deleted'
      redirect_to root_path
    else  
      flash[:notice] = 'Failed to delete expense'
      render :destroy
    end
  end

  private
  def expense_params 
    params.required(:expense).permit(:name, :amount)
  end

  # private 
  # def get_transaction
  #   @transaction = Transaction.find(params[:transaction_id])
  # end 
end
