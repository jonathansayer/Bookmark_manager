require 'spec_helper'
require 'sinatra'

feature 'User sign up' do 
  scenario ' I can sign up as a new user' do 
    expect { sign_up }. to change(User, :count).by(1)
    expect(page).to have_content('Welcome, alice@example.com')
    expect(User.first.email).to eq ('alice@example.com')
  end

  scenario 'with a password that does not match' do 
    expect { sign_up(password_confirmation: 'wrong') }.not_to change(User, :count)
    expect(current_path). to eq('/users')
    expect(page).to have_content 'Password does not match the confirmation'
  end

  def sign_up(email: 'alice@example.com', 
              password: 'oranges!',
              password_confirmation: 'oranges!')
    visit '/users/new'
    expect(page.status_code).to eq(200)
    fill_in :email, with: email
    fill_in :password, with: password
    fill_in :password_confirmation, with: password_confirmation
    click_button 'Sign up'
  end 

end