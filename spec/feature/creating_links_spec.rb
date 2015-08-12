require 'spec_helper'
require_relative '../../data_mapper_setup.rb'

feature 'Creating links' do 

	scenario "I can create a new link" do
		visit "/links/new"
		fill_in "url", with: "http://www.zombo.com/"
		fill_in 'title', with: "This is Zombocom"
		fill_in 'tags', with: "hard rock, pop"
    click_button 'Create link'
    expect(current_path).to eq "/links"

    #within "ul#links" do
    #	expect(page).to have_content("This is Zombocom")
    #end
	end

	scenario 'there are no links in the database at the start of the test' do
  	expect(Link.count).to eq 0
	end

end