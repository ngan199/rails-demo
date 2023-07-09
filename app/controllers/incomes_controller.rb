class IncomesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_income, only: %i[edit show destroy update]

  def index
    @income = current_user.incomes.where(deleted: false).order(created_at: :desc)
  end

  def new
    @transaction = Income.new
  end

  def show
    @transaction = current_user.incomes.where(deleted: false).order(created_at: :desc)
  end

  def edit; end

  def create
    begin
      message = 'Income existed'

      income = Income.find_or_create_by(
        user_id: current_user.id,
        deleted: false,
        year: params[:date]['year'],
        month: params[:date]['month']
      ) do |tr| 
        message = 'Income was successfully created'
      end
  
      flash[:notice] = message 

      redirect_to income_income_details_path(income)
    rescue Exception => e
      flash[:notice] = e.message
      render :new
    end
  end

  def update; end

  def destroy
    if @income.update(deleted: true) 
      income_detail = @income.income_details
      expenses.each do |e|
        e.update(deleted: true)
      end
      flash[:notice] = 'Income deleted'
    else  
      flash[:alert] = @transaction.errors
    end

    respond_to do |format|
      format.html { redirect_to incomes_path, notice: "Deleted income" }
    end
  end

  private

  def set_income
    @income = Income.find(params[:id])
  end

  def income_params
    params.require(:date).permit(true)
  end

  def total_amount(income)
    return 0 if income[:expenses_attributes].blank?

    values_array = income[:expenses_attributes].values.flatten
    numbers_array = values_array.pluck(:amount).map(&:to_f)
    numbers_array.compact.sum
  end
end
