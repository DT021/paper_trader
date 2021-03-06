class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :stocks, through: :portfolios
  has_many :trades

  def stock_quantity(stock)
    total_stock_owned = 0
    Trade.where({user_id: [@user.id], stock_id: [stock.id]}).each do |t|
      total_stock_owned += t.quantity
    end
    total_stock_owned
  end

  def portfolio_update(user)
    @user = user
    Trade.where({user_id: [@user.id]}).each do |t|
      @shares = stock_quantity(t.stock)
      portfolio = Portfolio.where({user_id: [@user.id], stock_id: [t.stock_id]})
      if portfolio != []
        portfolio.update(:shares => @shares)
      else
        portfolio = Portfolio.new(:user_id => @user.id, :stock_id => t.stock.id, :shares => @shares)
        portfolio.save
      end
    end
    Portfolio.where(:shares => 0).destroy_all
  end

  def buy_stock(user, stock, quantity)
    @user = user
    @stock_hold = stock.current_price * quantity

    if @user.cash >= @stock_hold
      trade = Trade.new(:user => @user, :stock => stock, :quantity => quantity, :buy_sell_price => stock.current_price, :log_time => Time.now())
      @user.cash -= @stock_hold
      trade.save
      @user.save
    else
      return false
    end
  end

  def sell_stock(user, stock, quantity)
    @user = user
    @stocks_owned = stock_quantity(stock)

    @current_trade_hold = stock.current_price * quantity

    if @stocks_owned > 0 && @stocks_owned >= quantity
      trade = Trade.new(:user => @user, :stock => stock, :quantity => -(quantity), :buy_sell_price => stock.current_price, :log_time => Time.now())
      @user.cash += @current_trade_hold
      stock.save
      trade.save
      @user.save
    else
      return false
    end
  end
end
