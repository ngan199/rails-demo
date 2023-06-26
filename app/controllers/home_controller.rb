class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    year = params[:search].blank? ? Date.today.year : params[:search]['year(1i)']
    month = params[:search].blank? ? Date.today.month : params[:search]['year(2i)']

    @transaction = current_user.transactions.order(created_at: :desc)
      .find_by(year: year, month: month)
      puts "@transaction #{@transaction.inspect}"
    @income = current_user.incomes.order(created_at: :desc)
      .find_by(year: year, month: month)
  end
end
