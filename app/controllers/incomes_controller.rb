class IncomesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_income, only: %i[edit show destroy update]

  def index 
    @income = current_user.incomes.order(created_at: :desc)
  end

  def new
    @income = Income.new 
    puts "params #{@params.inspect}"
    puts "income params #{@income_params.inspect}"
    IncomesHelper::IncomeNames.map do |name| 
      @income.income_details.build(name: name)
    end
  end

  def create
    @income = Income.new(
      income_params.merge(user_id: current_user.id)
    )

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
end
