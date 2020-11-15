require 'test_helper'

class RequestsControllerTest < ActionDispatch::IntegrationTest
  test 'should get positive redirect' do
    get "/requests/positive_redirect"
    assert_response :success
  end

  test 'should get negative redirect' do
    get "/requests/negative_redirect"
    assert_response :success
  end
    
end
