require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop do
        active = page.evaluate_script('jQuery.active')
        break if active == 0
      end
    end
  end

  def checkout_secure_web_page
    visit store_index_url

    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'
  end

  def checkout_iframe
    visit store_index_url

    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Iframe'
    wait_for_ajax
  end
end
