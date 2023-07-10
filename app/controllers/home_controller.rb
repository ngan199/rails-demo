class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    year = params[:search].blank? ? Date.today.year : params[:search]['year(1i)']
    month = params[:search].blank? ? Date.today.month : params[:search]['year(2i)']

    @transactions = current_user.transactions.order(created_at: :desc).find_by(year: year, month: month, deleted: false)
    @incomes = current_user.incomes.order(created_at: :desc).find_by(year: year, month: month, deleted: false)
  end
end
