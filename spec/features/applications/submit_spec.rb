require 'rails_helper'

RSpec.describe 'the application submittal' do
  # As a visitor
    # When I visit an application's show page
    # And I have added one or more pets to the application
    # Then I see a section to submit my application
    # And in that section I see an input to enter why I would make a good owner for these pet(s)
    # When I fill in that input
    # And I click a button to submit this application
    # Then I am taken back to the application's show page
    # And I see an indicator that the application is "Pending"
    # And I see all the pets that I want to adopt
    # And I do not see a section to add more pets to this application
  it "can submit an application only after pets have been added" do
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

    expect(page).to_not have_button('Submit Application')
    expect(page).to_not have_link(shelter.pets.all[0].name)
    expect(page).to_not have_link(shelter.pets.all[1].name)

    shelter.pets.all.each do |pet|
      application.pets << pet
    end

    visit "/admin/applications/#{application.id}"
    # save_and_open_page

    expect(page).to have_link(shelter.pets.all[0].name)
    expect(page).to have_link(shelter.pets.all[1].name)
    expect(page).to have_button('Submit Application')

    fill_in 'Why you would make a good home for this pet:', with: application.applicant_description
    click_on('Submit Application')

    expect(current_path).to eq("/admin/applications/#{application.id}")
    visit "/admin/applications/#{application.id}"
    # save_and_open_page
    expect(page).to have_content("Application Status: Pending")
    expect(page).to have_content("Applicant Description: #{application.applicant_description}")
  end

end
