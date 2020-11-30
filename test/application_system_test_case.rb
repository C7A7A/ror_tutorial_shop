require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  def checkout 
    visit store_index_url

    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'
  end

  def login
    if respond_to? :visit
      visit login_url
      fill_in :name, with: users(:one).name
      fill_in :password, with: 'secret'
      click_on 'Login'
    else
      post login_url, params: { name: user(:one).name, password: 'secret' } 
    end
  end
end
