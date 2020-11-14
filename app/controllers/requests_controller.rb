class RequestsController < ApplicationController
  skip_before_action :authorize
  
  def positive_redirect
  end

  def negative_redirect
  end
end
