require "application_system_test_case"

class LineItemsTest < ApplicationSystemTestCase
  test "visiting the index" do
    login
    visit line_items_url
    assert_selector "h1", text: "Line Items"
  end

  test "destroying a Line item" do
    visit line_items_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Line item was successfully destroyed."
  end
end
