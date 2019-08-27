class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.search_symbol(query)
    RestClient::Request.execute(
      method: :get,
      url: "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=#{query}&apikey=#{ENV['ALPHA_VANTAGE_API_KEY']}")
  end

end
