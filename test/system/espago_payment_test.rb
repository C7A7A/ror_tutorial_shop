require "application_system_test_case"

class EspagoPaymentTest < ApplicationSystemTestCase
  # setup do
  #   visit store_index_url

  #   click_on 'Add to Cart', match: :first
  #   click_on 'Checkout'

  #   click_on 'Place Order'
  # end

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

  test 'payment rejected 3DS' do
    visit store_index_url

    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    fill_in 'transaction_credit_card_attributes_first_name', with: 'espago payment'
    fill_in 'transaction_credit_card_attributes_last_name', with: 'executed 3DS'
    fill_in 'transaction_credit_card_attributes_number', with: '4012 0010 3714 1112'
    select '12', from: 'transaction_credit_card_attributes_month'
    select '30', from: 'transaction_credit_card_attributes_year'
    fill_in 'transaction_credit_card_attributes_verification_value', with: '123'

    click_on 'submit_payment'

    Capybara.using_wait_time(5) do
      fill_in 'code', with: '6666'

      click_on 'Prześlij | Send'
    end

    assert_text 'NEGATIVE REDIRECT'
  end

  test 'payment executed eDCC' do
    visit store_index_url

    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    fill_in 'transaction_credit_card_attributes_first_name', with: 'espago payment'
    fill_in 'transaction_credit_card_attributes_last_name', with: 'executed eDCC'
    fill_in 'transaction_credit_card_attributes_number', with: '4242 4211 1111 2239'
    select '01', from: 'transaction_credit_card_attributes_month'
    select '30', from: 'transaction_credit_card_attributes_year'
    fill_in 'transaction_credit_card_attributes_verification_value', with: '123'

    click_on 'submit_payment'

    choose 'dcc_yes'

    click_on 'submit_payment'

    click_on 'Powrót do sklepu'

    assert_text 'POSITIVE REDIRECT'
  end

  test 'payment rejected eDCC' do
    visit store_index_url

    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    fill_in 'transaction_credit_card_attributes_first_name', with: 'espago payment'
    fill_in 'transaction_credit_card_attributes_last_name', with: 'rejected eDCC'
    fill_in 'transaction_credit_card_attributes_number', with: '4242 4211 1111 2239'
    select '12', from: 'transaction_credit_card_attributes_month'
    select '30', from: 'transaction_credit_card_attributes_year'
    fill_in 'transaction_credit_card_attributes_verification_value', with: '123'

    click_on 'submit_payment'

    choose 'dcc_no'

    click_on 'submit_payment'

    click_on 'Powrót do sklepu'

    assert_text 'NEGATIVE REDIRECT'
  end

  test 'payment executed 3DS + eDCC' do
    visit store_index_url

    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    fill_in 'transaction_credit_card_attributes_first_name', with: 'espago payment'
    fill_in 'transaction_credit_card_attributes_last_name', with: 'executed 3DS + eDCC'
    fill_in 'transaction_credit_card_attributes_number', with: '4012 8888 8888 1881'
    select '01', from: 'transaction_credit_card_attributes_month'
    select '30', from: 'transaction_credit_card_attributes_year'
    fill_in 'transaction_credit_card_attributes_verification_value', with: '123'

    click_on 'submit_payment'

    choose 'dcc_yes'

    click_on 'submit_payment'

    Capybara.using_wait_time(5) do
      fill_in 'code', with: '1234'

      click_on 'Prześlij | Send'
    end

    assert_text 'POSITIVE REDIRECT'
  end

  test 'payment rejected 3DS + eDCC' do
    visit store_index_url

    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    fill_in 'transaction_credit_card_attributes_first_name', with: 'espago payment'
    fill_in 'transaction_credit_card_attributes_last_name', with: 'refused 3DS + eDCC'
    fill_in 'transaction_credit_card_attributes_number', with: '4012 8888 8888 1881'
    select '12', from: 'transaction_credit_card_attributes_month'
    select '30', from: 'transaction_credit_card_attributes_year'
    fill_in 'transaction_credit_card_attributes_verification_value', with: '123'

    click_on 'submit_payment'

    choose 'dcc_no'

    click_on 'submit_payment'

    Capybara.using_wait_time(5) do
      fill_in 'code', with: '6666'

      click_on 'Prześlij | Send'
    end

    assert_text 'NEGATIVE REDIRECT'
  end
  
end