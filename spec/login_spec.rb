require_relative 'helpers/spec_helper'

feature 'Entering the web page' do
  scenario 'Logging in' do
    visit '/account/login'
    expect(page).to have_content 'Login!'
    within '#loginForm' do
      fill_in 'email',    with: Helper.TEST_EMAIL
      fill_in 'password', with: Helper.TEST_PASSWORD
    end
    click_button 'Log in'
    expect(page).to have_content 'You are already logged in'
  end
end
