require "application_system_test_case"

class EspagoPaymentTest < ApplicationSystemTestCase
  test 'payment executed' do
    visit store_index_url

    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    fill_in 'transaction_credit_card_attributes_first_name', with: 'espago payment'
    fill_in 'transaction_credit_card_attributes_last_name', with: 'executed'
    fill_in 'transaction_credit_card_attributes_number', with: '4242 4242 4242 4242'
    select '01', from: 'transaction_credit_card_attributes_month'
    select '30', from: 'transaction_credit_card_attributes_year'
    fill_in 'transaction_credit_card_attributes_verification_value', with: '123'

    click_on 'submit_payment'

    click_on 'Powrót do sklepu'

    assert_text 'POSITIVE REDIRECT'
  end

  test 'payment rejected' do
    visit store_index_url

    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    fill_in 'transaction_credit_card_attributes_first_name', with: 'espago payment'
    fill_in 'transaction_credit_card_attributes_last_name', with: 'rejected'
    fill_in 'transaction_credit_card_attributes_number', with: '4242 4242 4242 4242'
    select '12', from: 'transaction_credit_card_attributes_month'
    select '30', from: 'transaction_credit_card_attributes_year'
    fill_in 'transaction_credit_card_attributes_verification_value', with: '123'

    click_on 'submit_payment'

    click_on 'Powrót do sklepu'

    assert_text 'NEGATIVE REDIRECT'
  end

  test 'payment executed 3DS' do
    visit store_index_url

    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    fill_in 'transaction_credit_card_attributes_first_name', with: 'espago payment'
    fill_in 'transaction_credit_card_attributes_last_name', with: 'executed 3DS'
    fill_in 'transaction_credit_card_attributes_number', with: '4012 0010 3714 1112'
    select '01', from: 'transaction_credit_card_attributes_month'
    select '30', from: 'transaction_credit_card_attributes_year'
    fill_in 'transaction_credit_card_attributes_verification_value', with: '123'

    click_on 'submit_payment'

    Capybara.using_wait_time(5) do
      fill_in 'code', with: '1234'

      click_on 'Prześlij | Send'
    end

    assert_text 'POSITIVE REDIRECT'
  end

  
end