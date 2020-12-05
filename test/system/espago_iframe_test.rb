require "application_system_test_case"

class EspagoIframeTest < ApplicationSystemTestCase
  setup do
    checkout_iframe
  end

  test 'payment executed' do
    within_frame 'EspagoFrame' do
      fill_in 'espago_first_name', with: 'espago payment'
      fill_in 'espago_last_name', with: 'executed'
      fill_in 'espago_card_number', with: '4242 4242 4242 4242'
      fill_in 'espago_month', with: '01'
      fill_in 'espago_year', with: '2030'
      fill_in 'espago_verification_value', with: '123'
  
      click_on 'Pay'
    end

    Capybara.using_wait_time(5) do
      assert_text 'POSITIVE REDIRECT'
    end
  end

  test 'payment rejected' do
    within_frame 'EspagoFrame' do
      fill_in 'espago_first_name', with: 'espago payment'
      fill_in 'espago_last_name', with: 'rejected'
      fill_in 'espago_card_number', with: '4242 4242 4242 4242'
      fill_in 'espago_month', with: '12'
      fill_in 'espago_year', with: '2030'
      fill_in 'espago_verification_value', with: '123'
  
      click_on 'Pay'
    end

    Capybara.using_wait_time(5) do
      assert_text 'NEGATIVE REDIRECT'
    end
  end

  test 'payment executed 3DS' do
    within_frame 'EspagoFrame' do
      fill_in 'espago_first_name', with: 'espago payment'
      fill_in 'espago_last_name', with: 'executed 3DS'
      fill_in 'espago_card_number', with: '4012 0010 3714 1112'
      fill_in 'espago_month', with: '01'
      fill_in 'espago_year', with: '2030'
      fill_in 'espago_verification_value', with: '123'
      
      click_on 'Pay'
    end

    Capybara.using_wait_time(5) do
      fill_in 'code', with: '1234'
      click_on 'Prześlij | Send'
    end

    assert_text 'POSITIVE REDIRECT'
  end

  test 'payment rejected 3DS' do
    within_frame 'EspagoFrame' do
      fill_in 'espago_first_name', with: 'espago payment'
      fill_in 'espago_last_name', with: 'executed 3DS'
      fill_in 'espago_card_number', with: '4012 0010 3714 1112'
      fill_in 'espago_month', with: '12'
      fill_in 'espago_year', with: '2030'
      fill_in 'espago_verification_value', with: '123'
    
      click_on 'Pay'
    end

    Capybara.using_wait_time(5) do
      fill_in 'code', with: '6666'
      click_on 'Prześlij | Send'
    end

    assert_text 'NEGATIVE REDIRECT'
  end

  test 'payment executed eDCC' do
    within_frame 'EspagoFrame' do
      fill_in 'espago_first_name', with: 'espago payment'
      fill_in 'espago_last_name', with: 'executed eDCC'
      fill_in 'espago_card_number', with: '4242 4211 1111 2239'
      fill_in 'espago_month', with: '01'
      fill_in 'espago_year', with: '2030'
      fill_in 'espago_verification_value', with: '123'
    
      click_on 'Pay'
    end

    Capybara.using_wait_time(5) do
      choose 'dcc_yes'
      click_on 'submit_payment'
      click_on 'Powrót do sklepu'
    end

    assert_text 'POSITIVE REDIRECT'
  end

  test 'payment rejected eDCC' do
    within_frame 'EspagoFrame' do
      fill_in 'espago_first_name', with: 'espago payment'
      fill_in 'espago_last_name', with: 'rejected eDCC'
      fill_in 'espago_card_number', with: '4242 4211 1111 2239'
      fill_in 'espago_month', with: '12'
      fill_in 'espago_year', with: '2030'
      fill_in 'espago_verification_value', with: '123'
    
      click_on 'Pay'
    end

    Capybara.using_wait_time(5) do
      choose 'dcc_no'
      click_on 'submit_payment'
      click_on 'Powrót do sklepu'
    end

    assert_text 'NEGATIVE REDIRECT'
  end

  test 'payment executed 3DS + eDCC' do
    within_frame 'EspagoFrame' do
      fill_in 'espago_first_name', with: 'espago payment'
      fill_in 'espago_last_name', with: 'executed 3DS + eDCC'
      fill_in 'espago_card_number', with: '4012 8888 8888 1881'
      fill_in 'espago_month', with: '01'
      fill_in 'espago_year', with: '2030'
      fill_in 'espago_verification_value', with: '123'
    
      click_on 'Pay'
    end

    Capybara.using_wait_time(5) do
      choose 'dcc_yes'
      click_on 'submit_payment'
    end

    Capybara.using_wait_time(5) do
      fill_in 'code', with: '1234'
      click_on 'Prześlij | Send'
    end

    assert_text 'POSITIVE REDIRECT'
  end

  test 'payment rejected 3DS + eDCC' do
    within_frame 'EspagoFrame' do
      fill_in 'espago_first_name', with: 'espago payment'
      fill_in 'espago_last_name', with: 'refused 3DS + eDCC'
      fill_in 'espago_card_number', with: '4012 8888 8888 1881'
      fill_in 'espago_month', with: '12'
      fill_in 'espago_year', with: '2030'
      fill_in 'espago_verification_value', with: '123'
    
      click_on 'Pay'
    end

    Capybara.using_wait_time(5) do
      choose 'dcc_no'
      click_on 'submit_payment'
    end

    Capybara.using_wait_time(5) do
      fill_in 'code', with: '6666'
      click_on 'Prześlij | Send'
    end

    assert_text 'NEGATIVE REDIRECT'
  end
end