require_relative 'helpers/spec_helper'

feature 'Entering the web page' do
  scenario 'Logging in' do
    visit '/account/login'
    expect(page).to have_content 'Logga in!'
    within '#loginForm' do
      fill_in 'email',    with: Helper.TEST_EMAIL
      fill_in 'password', with: Helper.TEST_PASSWORD
    end
    click_button 'Logga in'
    expect(page).to have_content 'Game Overview'
  end

  scenario 'Failing to log in' do
    visit '/account/login'
    expect(page).to have_content 'Logga in!'
    within '#loginForm' do
      fill_in 'email',    with: Helper.TEST_EMAIL
      fill_in 'password', with: 'asdjasl'
    end
    click_button 'Logga in'
    expect(page).to have_content 'Emailen och lösenordet stämde inte överens'
  end

  scenario 'Creating Account' do
    visit '/account/new'
    expect(page).to have_content 'Skapa konto'
    within '#createForm' do
      fill_in 'firstName',       with: 'Vincent'
      fill_in 'lastName',        with: 'Udén'
      fill_in 'email',           with: 'vincentuden@gmail.com'
      fill_in 'class',           with: '3A'
      fill_in 'password',        with: 'testpass123'
      fill_in 'passwordConfirm', with: 'testpass123'
      fill_in 'codeWord',        with: 'green-alligator-nurse'
    end
    click_button 'Skapa konto'
    expect(page).to have_content 'Logga in!'
  end
  
  scenario 'Failing to create an account' do
    visit '/account/new'
    expect(page).to have_content 'Skapa konto'
    within '#createForm' do
      fill_in 'firstName',       with: ''
      fill_in 'lastName',        with: 'Udén'
      fill_in 'email',           with: Helper.TEST_EMAIL
      fill_in 'class',           with: '4A'
      fill_in 'password',        with: 'testpass123'
      fill_in 'passwordConfirm', with: 'testpass1234'
      fill_in 'codeWord',        with: 'crimson-alligator-nurse'
    end
    click_button 'Skapa konto'
    expect(page).to have_content 'Skapa konto'
    expect(page).to have_content 'Du måste ange ett förnamn'
    expect(page).to have_content 'Email adressen är redan använd'
    expect(page).to have_content 'Du måste ange en korrekt klass'
    expect(page).to have_content 'Lösenorden måste matcha'
    expect(page).to have_content 'Felaktig kod'
  end
end
