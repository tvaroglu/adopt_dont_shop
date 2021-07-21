require 'rails_helper'

RSpec.describe 'the application pet search' do
  # As a visitor
    # When I visit an application's show page
    # And that application has not been submitted,
    # Then I see a section on the page to "Add a Pet to this Application"
    # In that section I see an input where I can search for Pets by name
    # When I fill in this field with a Pet's name
    # And I click submit,
    # Then I am taken back to the application show page
    # And under the search bar I see any Pet whose name matches my search
  it "can add pets to an unsubmitted application via case-insensitive and/or partial search" do
    shelter = Shelter.create!(
      name: 'Aurora Shelter',
      address: '123 Main St.',
      city: 'Aurora',
      state: 'CO',
      zipcode: '80010',
      foster_program: false,
      rank: 9)

    shelter.pets.create!(
      name: 'Mr. Pirate',
      breed: 'Tuxedo Shorthair',
      age: 5,
      adoptable: true)
    shelter.pets.create!(
      name: 'Clawdia',
      breed: 'Exotic Shorthair',
      age: 3,
      adoptable: true)
    shelter.pets.create!(
      name: 'Ann',
      breed: 'Ragdoll',
      age: 3,
      adoptable: false)

    application = Application.create!(
      applicant_fullname: 'John Smith',
      applicant_address: '1200 3rd St.',
      applicant_city: 'Golden',
      applicant_state: 'CO',
      applicant_zipcode: '80401',
      applicant_description: 'I am a good guy',
      status: 'In Progress')

    visit "/admin/applications/#{application.id}"
    # save_and_open_page

    expect(page).to have_content('Add Pets to Application')
    expect(page).to have_button('Search Pets')
    expect(page).to_not have_link(shelter.pets.all[0].name)
    expect(page).to_not have_link(shelter.pets.all[1].name)
    expect(page).to_not have_link(shelter.pets.all[2].name)

    fill_in 'Pet Name:', with: shelter.pets.all[0].name[1..3].upcase
    click_on('Search Pets')

    expect(current_path).to eq("/admin/applications/#{application.id}/search")
    expect(page).to have_button("Return to Application")

    click_on("Add #{shelter.pets.all[0].name}")

    expect(current_path).to eq("/admin/applications/#{application.id}")
    expect(page).to have_link(shelter.pets.all[0].name)
    expect(page).to_not have_link(shelter.pets.all[1].name)
    expect(page).to_not have_link(shelter.pets.all[2].name)
  end

  it "can't add pets to a submitted application" do
    shelter = Shelter.create!(
      name: 'Aurora Shelter',
      address: '123 Main St.',
      city: 'Aurora',
      state: 'CO',
      zipcode: '80010',
      foster_program: false,
      rank: 9)

    shelter.pets.create!(
      name: 'Mr. Pirate',
      breed: 'Tuxedo Shorthair',
      age: 5,
      adoptable: true)
    shelter.pets.create!(
      name: 'Clawdia',
      breed: 'Exotic Shorthair',
      age: 3,
      adoptable: true)
    shelter.pets.create!(
      name: 'Ann',
      breed: 'Ragdoll',
      age: 3,
      adoptable: false)

    application = Application.create!(
      applicant_fullname: 'John Smith',
      applicant_address: '1200 3rd St.',
      applicant_city: 'Golden',
      applicant_state: 'CO',
      applicant_zipcode: '80401',
      applicant_description: 'I am a good guy',
      status: 'Pending')
    shelter.pets.all.each do |pet|
      application.pets << pet
    end

    visit "/admin/applications/#{application.id}"
    # save_and_open_page

    expect(page).to have_link(shelter.pets.all[0].name)
    expect(page).to have_link(shelter.pets.all[1].name)
    expect(page).to have_link(shelter.pets.all[2].name)
    expect(page).to_not have_content('Add Pets to Application')
  end
end
