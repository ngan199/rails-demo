class IncomeDetailsController < ApplicationController
  before_action :get_income
  before_action :prepare_create, only: [:create]
  before_action :set_income_detail, only: [:show, :edit, :update, :destroy]

  def index 
    @income_detail = IncomeDetail.where(income_id: params[:income_id], deleted: false)
  end 

  def show
    @income_detail = IncomeDetail.where(income_id: params[:income_id], deleted: false)
  end

  def new
    @income_detail = @income.income_details.build
  end

  def create
    respond_to do |format| 
      if @income_detail.save 
        income = IncomeDetail.where(income_id: @income_detail.income_id)
        @income.update(total: total_amount(income))

        format.turbo_stream 
        format.html {redirect_to income_income_details_path(@income), notice: "Income was successfully created"}
      else  
        format.html { render :new, status: :unprocessable_entity}
      end
    end
  end

  def edit; end

  def update; end

  def destroy
    @income_detail.update(deleted: true)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("#{helpers.dom_id(@income_detail)}_container") }
      format.html { redirect_to income_income_details_path, notice: "Deleted income detail" }
    end
  end

  private 
  def get_income 
    @income = Income.find(params[:income_id])
  end

  def income_detail_params 
    params.required(:income_detail).permit(:name, :amount)
  end

  def prepare_create
    @income_detail = IncomeDetail.new(income_detail_params.merge(
      income_id: params[:income_id],
      deleted: false
    ))
  end

  def set_income_detail 
    @income_detail = IncomeDetail.find(params[:id])
  end

  def total_amount(transaction)
    return 0 if transaction.blank?

    numbers_array = transaction.pluck(:amount).map(&:to_f)
    numbers_array.compact.sum
  end
end
