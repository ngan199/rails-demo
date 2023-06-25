class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @transaction = current_user.transactions.order(created_at: :desc)
    .find_by(year: params[:search]['year(1i)'], month: params[:search]['year(2i)']) || []

    @income = current_user.incomes.order(created_at: :desc)
    .find_by(year: params[:search]['year(1i)'], month: params[:search]['year(2i)']) || []
  end
end
