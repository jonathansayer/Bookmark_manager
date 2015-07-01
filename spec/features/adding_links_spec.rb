require 'spec_helper'

feature 'User adds a new link' do 

scenario 'using the new link form' do 
  visit '/links/new'
  fill_in 'url',  with: 'http://www.zombo.com/'
  fill_in 'title', with: 'This is Zombocom'
  click_button 'Add link'
  expect(Link.count).to eq(1)
  expect(current_path).to eq '/links'
  expect(page).to have_content('http://www.zombo.com/')
  expect(page).to have_content('This is Zombocom')
  end

  scenario 'there are no links in the database at the start of the test' do 
    expect(Link.count).to eq 0
  end 
end
