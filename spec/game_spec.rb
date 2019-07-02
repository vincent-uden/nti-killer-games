require_relative 'helpers/spec_helper'

feature 'Living/Dying' do
  before :each do
    visit '/account/login'
    within '#loginForm' do
      fill_in 'email',    with: Helper.TEST_EMAIL
      fill_in 'password', with: Helper.TEST_PASSWORD
    end
    click_button 'Logga in'
  end

  scenario 'Getting killed' do
    visit '/'
    click_button 'Jag har blivit mördad'
    expect(page).to have_content 'Du är död'
  end
end
