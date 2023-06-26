class IncomesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_income, only: %i[edit show destroy update]
  before_action :prepare_create, only: :create

  def index 
    @income = current_user.incomes.order(created_at: :desc)
  end

  def new
    @income = Income.new 
    IncomesHelper::IncomeNames.map do |name| 
      @income.income_details.build(name: name)
    end
  end

  def create
    if @income.save 
      flash[:notice] = 'Income was successfully created'
      redirect_to incomes_path
    else 
      flash[:notice] = @income.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    if @income.update(income_params)
      flash[:notice] = 'Income updated'
      redirect_to incomes_path
    else  
      flash[:alert] = 'Failed to edit income'
      render :edit 
    end
  end

  def destroy
    if @income.update(display: false)
      flash[:notice] = 'Income deleted'
    else  
      flash[:alert] = @income.errors
    end

    redirect_to transactions_path
  end

  private 
  def set_income 
    @income = Income.find(params[:id])
  end

  def income_params 
    params.required(:income).permit(:total, income_details_attributes: %i[name amount])
  end

  def prepare_create
    @income = Income.new(
      income_params.merge(
        display: true,
        user_id: current_user.id,
        year: params[:date]['year'],
        month: params[:date]['month'],
        total: total_amount(params[:income])
      )
    )
  end

  def total_amount(income)
    return 0 if income[:income_details_attributes].blank?

    values_array = income[:income_details_attributes].values.flatten
    numbers_array = values_array.pluck(:amount).map(&:to_f)
    numbers_array.compact.sum
  end
end
