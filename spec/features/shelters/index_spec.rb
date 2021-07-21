require 'rails_helper'

RSpec.describe 'the shelters index' do
  before(:each) do
    @shelter_1 = Shelter.create!(
      name: 'Fancy Pets of Colorado',
      address: '1200 Cedar Ct.',
      city: 'Aurora',
      state: 'CO',
      zipcode: '80010',
      foster_program: false,
      rank: 9)
    @shelter_2 = Shelter.create!(
      name: 'RGV Animal Shelter',
      address: '1900 N Stemmons Fwy.',
      city: 'Dallas',
      state: 'TX',
      zipcode: '75001',
      foster_program: false,
      rank: 5)
    @shelter_3 = Shelter.create!(
      name: 'Denver Metro Shelter',
      address: '8300 Colfax Ave.',
      city: 'Denver',
      state: 'CO',
      zipcode: '80014',
      foster_program: true,
      rank: 10)

    @shelter_1.pets.create!(
      name: 'Mr. Pirate',
      breed: 'Tuxedo Shorthair',
      age: 5,
      adoptable: false)
    @shelter_1.pets.create!(
      name: 'Clawdia',
      breed: 'Exotic Shorthair',
      age: 3,
      adoptable: true)
    @shelter_3.pets.create!(
      name: 'Lucille Bald',
      breed: 'Sphynx',
      age: 8,
      adoptable: true)
  end

  # As a visitor
    # When I visit the admin shelter index ('/admin/shelters')
    # Then I see all Shelters in the system listed in reverse alphabetical order by name
  it 'lists the shelters in reverse alphabetical order by name' do
    visit "/admin/shelters"
    # save_and_open_page

    first = find("#shelter-#{@shelter_2.id}")
    second = find("#shelter-#{@shelter_1.id}")
    third = find("#shelter-#{@shelter_3.id}")

    expect(first).to appear_before(second)
    expect(second).to appear_before(third)

    within "#shelter-#{@shelter_1.id}" do
      expect(page).to have_link(@shelter_1.name)
      expect(page).to have_content("Created at: #{@shelter_1.created_at}")
    end

    within "#shelter-#{@shelter_2.id}" do
      expect(page).to have_link(@shelter_2.name)
      expect(page).to have_content("Created at: #{@shelter_2.created_at}")
    end

    within "#shelter-#{@shelter_3.id}" do
      expect(page).to have_link(@shelter_3.name)
      expect(page).to have_content("Created at: #{@shelter_3.created_at}")
    end
  end

  # As a visitor
    # When I visit the admin shelter index ('/admin/shelters')
    # Then I see a section for "Shelter's with Pending Applications"
    # And in this section I see the name of every shelter that has a pending application
  describe 'shelters with pending applications' do
    it "doesn't display the section if no applications are pending" do
      visit "/admin/shelters"
      # save_and_open_page

      application_1 = Application.create!(
        applicant_fullname: 'John Smith',
        applicant_address: '1200 3rd St.',
        applicant_city: 'Golden',
        applicant_state: 'CO',
        applicant_zipcode: '80401',
        applicant_description: 'I am a good guy',
        status: 'In Progress')
      application_2 = Application.create!(
        applicant_fullname: 'Jane Doe',
        applicant_address: '500 Poplar Ave.',
        applicant_city: 'Wheat Ridge',
        applicant_state: 'CO',
        applicant_zipcode: '80401',
        applicant_description: 'I want a kitty!',
        status: 'In Progress')

      application_1.pets << @shelter_1.pets.all.first
      application_2.pets << @shelter_1.pets.all.first

      within "#pending-apps" do
        expect(page).to_not have_content("Shelters With Pending Applications:")
        expect(page).to_not have_link(@shelter_1.name)
        expect(page).to_not have_link(@shelter_2.name)
        expect(page).to_not have_link(@shelter_3.name)
      end
    end
    # As a visitor
    #   When I visit the admin shelter index ('/admin/shelters')
    #   And I look in the section for shelters with pending applications
    #   Then I see all those shelters are listed alphabetically
    it 'displays the section in alphabetical order if applications are pending' do
      application_1 = Application.create!(
        applicant_fullname: 'John Smith',
        applicant_address: '1200 3rd St.',
        applicant_city: 'Golden',
        applicant_state: 'CO',
        applicant_zipcode: '80401',
        applicant_description: 'I am a good guy',
        status: 'Pending')
      application_2 = Application.create!(
        applicant_fullname: 'Jane Doe',
        applicant_address: '500 Poplar Ave.',
        applicant_city: 'Wheat Ridge',
        applicant_state: 'CO',
        applicant_zipcode: '80401',
        applicant_description: 'I want a kitty!',
        status: 'Pending')

      application_1.pets << @shelter_1.pets.all.last
      application_2.pets << @shelter_1.pets.all.last
      application_2.pets << @shelter_3.pets.all.last

      visit "/admin/shelters"
      # save_and_open_page

      within "#pending-apps" do
        expect(page).to have_content("Shelters With Pending Applications:")
        expect(page).to have_link(@shelter_1.name)
        expect(page).to have_link(@shelter_3.name)
        expect(page).to_not have_link(@shelter_2.name)

        expect(@shelter_3.name).to appear_before(@shelter_1.name)
      end
    end
  end

  it 'has a link to sort shelters by the number of pets they have' do
    visit "/admin/shelters"

    expect(page).to have_button("Sort by: Number of Pets")
    click_on("Sort by: Number of Pets")

    expect(page).to have_current_path('/admin/shelters?sort=pet_count')
    expect(@shelter_1.name).to appear_before(@shelter_3.name)
    expect(@shelter_3.name).to appear_before(@shelter_2.name)
  end

  it 'has a button to update each shelter' do
    visit "/admin/shelters"

    within "#shelter-#{@shelter_1.id}" do
      expect(page).to have_button("Update: #{@shelter_1.name}")
    end

    within "#shelter-#{@shelter_2.id}" do
      expect(page).to have_button("Update: #{@shelter_2.name}")
    end

    within "#shelter-#{@shelter_3.id}" do
      expect(page).to have_button("Update: #{@shelter_3.name}")
    end

    click_on("Update: #{@shelter_1.name}")
    expect(page).to have_current_path("/admin/shelters/#{@shelter_1.id}/edit")
  end

  it 'has a button to delete each shelter' do
    visit "/admin/shelters"

    within "#shelter-#{@shelter_1.id}" do
      expect(page).to have_button("Delete: #{@shelter_1.name}")
    end

    within "#shelter-#{@shelter_2.id}" do
      expect(page).to have_button("Delete: #{@shelter_2.name}")
    end

    within "#shelter-#{@shelter_3.id}" do
      expect(page).to have_button("Delete: #{@shelter_3.name}")
    end

    click_on("Delete: #{@shelter_1.name}")
    expect(page).to have_current_path("/admin/shelters")
    expect(page).to_not have_content(@shelter_1.name)
  end

  it 'has a text box to filter results by keyword' do
    visit "/admin/shelters"
    expect(page).to have_button("Search")
  end

  it 'lists partial matches as search results' do
    visit "/admin/shelters"

    fill_in 'Search', with: "RGV"
    click_on("Search")

    expect(page).to have_content(@shelter_2.name)
    expect(page).to_not have_content(@shelter_1.name)
  end
end
