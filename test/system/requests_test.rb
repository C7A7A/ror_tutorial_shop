require 'application_system_test_case'

class RequestsTest < ApplicationSystemTestCase
  test 'visiting positive redirect' do
    visit '/requests/positive_redirect'
    assert_selector "div", text: "POSITIVE REDIRECT"
  end

  test 'visiting negative redirect' do
    visit '/requests/negative_redirect'
    assert_selector "div", text: "NEGATIVE REDIRECT"
  end
end