require 'byebug'
class TradesController < ApplicationController
  def create
    stock = Stock.find_by_id(params[:stock_id].to_i)
    if params[:commit] == "Buy"
      current_user.buy_stock(current_user, stock, params[:buy_qty].to_i)
      current_user.portfolio_update(current_user)
    elsif params[:commit] == "Sell"
      current_user.sell_stock(current_user, stock, params[:sell_qty].to_i)
      current_user.portfolio_update(current_user)
    end
    render :show
  end
end
