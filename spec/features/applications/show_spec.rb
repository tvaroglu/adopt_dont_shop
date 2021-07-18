require 'rails_helper'

RSpec.describe 'the application show' do
# As a visitor
  # When I visit an applications show page
  # Then I can see the following:
  # Name of the Applicant
  # Full Address of the Applicant including street address, city, state, and zip code
  # Description of why the applicant says they'd be a good home for this pet(s)
  # names of all pets that this application is for (all names of pets should be links to their show page)
  # The Application's status, either "In Progress", "Pending", "Accepted", or "Rejected"
  it "shows the application and all it's attributes" do
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

    shelter.pets.all.each do |pet|
      application.pets << pet
    end

    visit "/admin/applications/#{application.id}"
    # save_and_open_page

    expect(page).to have_content("Application: #{application.last_updated}")
    expect(page).to have_content("Name: #{application.applicant_fullname}")
    expect(page).to have_content("Address: #{application.full_address}")
    expect(page).to have_content("Description: #{application.applicant_description}")
    expect(page).to have_content("Status: #{application.status}")

    expect(page).to have_link(shelter.pets.all[0].name)
    expect(page).to have_link(shelter.pets.all[1].name)
    expect(page).to have_link(shelter.pets.all[2].name)
  end

  it "links to each pet's show pages" do
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

    shelter.pets.all.each do |pet|
      application.pets << pet
    end

    visit "/admin/applications/#{application.id}"
    # save_and_open_page

    click_on(application.pets.all[0].name)
    expect(current_path).to eq("/pets/#{shelter.pets.all[0].id}")
  end
end
