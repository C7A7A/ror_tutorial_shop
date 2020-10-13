class StoreController < ApplicationController
  def index
    @products = Product.order(:title)

    if session[:counter].nil? 
      session[:counter] = 0
    end
    session[:counter] = session[:counter] + 1

    @time = 'time'.pluralize(session[:counter])
  end
end
