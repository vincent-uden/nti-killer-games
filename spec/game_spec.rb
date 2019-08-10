require_relative 'helpers/spec_helper'

feature 'Living/Dying' do
  before :each do
    visit '/account/login'
    within '#loginForm' do
      fill_in 'email',    with: 'dario@example.net'
      fill_in 'password', with: Helper.TEST_PASSWORD
    end
    click_button 'Logga in'
  end

  scenario 'Getting killed' do
    GameState.set_running
    help_user = User.get email: 'dario@example.net'
    murderer = User.get target_id: help_user.get_id
    visit '/'
    click_button 'Jag har blivit dödad'
    sleep 0.6
    click_button 'Ja, jag har blivit dödad'
    expect(page).to have_content 'DU ÄR DÖD'
    new_murderer = User.get id: murderer.get_id
    # Ensure killer gets the right target
    expect(new_murderer.get_target_id).to eq(help_user.get_target_id)
  end
end
