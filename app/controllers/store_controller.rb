class StoreController < ApplicationController
  include CurrentCart

  skip_before_action :authorize

  before_action :set_cart

  def index
    @products = Product.order(:title)

    if session[:counter].nil? 
      session[:counter] = 0
    end
    session[:counter] = session[:counter] + 1

    @time = 'time'.pluralize(session[:counter])
  end
end
