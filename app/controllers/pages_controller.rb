class PagesController < ApplicationController

  def index
    render :index
  end

  def search
    if params[:search].blank?
      redirect_to(search_path) and return
    else
      @stock = Stock.search(params[:search])
    end
      redirect_to stock_url(@stock)
  end

end
