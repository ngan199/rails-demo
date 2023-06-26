class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:search].blank?
      @transaction = current_user.transactions.order(created_at: :desc)
      .find_by(year: Date.today.year, month: Date.today.month) || []

      @income = current_user.incomes.order(created_at: :desc)
      .find_by(year: Date.today.year, month: Date.today.month) || []

    else  
      @transaction = current_user.transactions.order(created_at: :desc)
      .find_by(year: params[:search]['year(1i)'], month: params[:search]['year(1i)']) || []

      @income = current_user.incomes.order(created_at: :desc)
      .find_by(year: params[:search]['year(1i)'], month: params[:search]['year(1i)']) || []
    end
  end
end
