require 'spec_helper'
require_relative '../../data_mapper_setup.rb'

feature 'Viewing links' do

  before(:each) do
    Link.create(url: 'http://www.makersacademy.com',
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
    Link.create(url: 'http://www.makersacademy.com', title: 'Makers Academy')

    visit '/links'

    # as this is our first feature test,
    # the following expectation is a quick check that everything is working.
    expect(page.status_code).to eq 200
    # you might remove this later.

    # why do we use within here?
    # might we get a false positive if we just test for 'Makers Academy'?
    within 'ul#links' do
      expect(page).to have_content('Makers Academy')
    end
  end

  scenario 'I can filter links by tag' do
    visit '/tags/bubbles'
    within 'ul#links' do
      expect(page).not_to have_content('Makers Academy')
      expect(page).not_to have_content('Code.org')
      expect(page).to have_content('This is Zombocom')
      expect(page).to have_content('Bubble Bobble')
      end
    end

    # scenario 'I can add multiple tags to a new link' do
    #   visit '/links/new'
    #   fill_in 'url',   with: 'http://www.makersacademy.com/'
    #   fill_in 'title', with: 'Makers Academy'
    #   # our tags will be space separated
    #   fill_in 'tags',  with: 'education ruby'
    #   click_button 'Create link'
    #   link = Link.first
    #   expect(link.tags.map(&:name)).to include('education', 'ruby')
    #   end
    # end
  end