class ExpensesController < ApplicationController
  before_action :get_transaction
  before_action :prepare_create, only: [:create]
  before_action :set_expense, only: [:show, :edit, :update, :destroy]
  
  def index 
    @expense = Expense.where(transaction_id: params[:transaction_id], deleted: false)
  end 

  def show
    @expense = Expense.find(params[:format])
  end

  def new
    @expense = @transaction.expenses.build
  end

  def create
    respond_to do |format|
      if @expense.save
        transaction = Expense.where(transaction_id: @expense.transaction_id)
        @transaction.update(total: total_amount(transaction))
        
        format.turbo_stream 
        format.html {redirct_to transaction_expenses_path(@transaction), notice: "Expense was successfully created"}
      else  
        format.html { render :new, status: :unprocessable_entity}
      end
    end
  end

  def edit
    expense = Expense.find(params[:format])
  end

  def update
    if @expense.update_attributes_(expense_params)
      flash[:notice] = 'Expense updaated'
      redirect_to root_path 
    else  
      flash[:errors] = 'Failed to edit expense'
      render :edit  
    end 
  end

  def destroy
    @expense.update(deleted: true)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("#{helpers.dom_id(@expense)}_container") }
      format.html { redirect_to transaction_expenses_path, notice: "Deleted expense" }
    end
  end

  private 
  def get_transaction 
    @transaction = Transaction.find(params[:transaction_id])
  end

  def expense_params 
    params.required(:expense).permit(:name, :amount)
  end

  def prepare_create 
    @expense = Expense.new(expense_params.merge(
      transaction_id: params[:transaction_id],
      deleted: false,
    ))
  end

  def set_expense 
    @expense = Expense.find(params[:id])
  end

  def total_amount(transaction)
    return 0 if transaction.blank?

    numbers_array = transaction.pluck(:amount).map(&:to_f)
    numbers_array.compact.sum
  end
end
