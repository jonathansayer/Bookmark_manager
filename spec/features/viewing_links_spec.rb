require 'spec_helper'
require 'sinatra'


feature 'Viewing links' do

   before(:each) do
  Link.create(url: 'http://www.makersacadem.com',
              title: 'Makers Academy', 
              tags: [Tag.first_or_create(name: 'education')])
  Link.create(url: 'http://www.google.com',
              title: 'Google',
              tags: [Tag.first_or_create(name: 'search')])
  Link.create(url: 'http://www.zombo.com',
              title: 'This is Zombocom',
              tags: [Tag.first_or_create(name: 'bubbles')])
  Link.create(url: 'http://www.bubble-bobble.com',
              title: 'Bubble Bobble',
              tags: [Tag.first_or_create(name: 'bubbles')])
  end 



  scenario 'I can see existing links on the links page' do
    Link.create(url: 'http://makersacademy.com', title: 'Makers Academy')
     user = double :user
    allow(user).to receive(:password) {true}
    allow(user).to receive(:password_confirmation) {true}
    
    visit '/links'

    expect(page.status_code).to eq 200

    within 'ul#links' do
      expect(page).to have_content('Makers Academy')
    end
  end

  scenario 'I can filter links by tag' do 
    visit '/tags/bubbles'
    expect(page).to_not have_content('Makers Academy')
    expect(page).to_not have_content('Code.org')
    expect(page).to have_content('This is Zombocom')
    expect(page).to have_content('Bubble Bobble')
  end 


end
