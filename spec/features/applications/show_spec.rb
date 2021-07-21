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
    expect(page).to have_content("Applicant Name: #{application.applicant_fullname}")
    expect(page).to have_content("Applicant Address: #{application.full_address}")
    expect(page).to have_content("Application Status: #{application.status}")
    expect(page).to_not have_content("Applicant Description: #{application.applicant_description}")

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

    expect(page).to_not have_button('Submit Application')
    expect(page).to_not have_link(shelter.pets.all[0].name)
    expect(page).to_not have_link(shelter.pets.all[1].name)
    expect(page).to_not have_link(shelter.pets.all[2].name)

    shelter.pets.all.each do |pet|
      application.pets << pet
    end

    visit "/admin/applications/#{application.id}"
    # save_and_open_page

    expect(page).to have_link(shelter.pets.all[0].name)
    expect(page).to have_link(shelter.pets.all[1].name)
    expect(page).to have_link(shelter.pets.all[2].name)
    expect(page).to have_button('Submit Application')

    fill_in 'Why you would make a good home for this pet:', with: application.applicant_description
    click_on('Submit Application')

    expect(current_path).to eq("/admin/applications/#{application.id}")
    visit "/admin/applications/#{application.id}"
    # save_and_open_page
    expect(page).to have_content("Application Status: Pending")
    expect(page).to have_content("Applicant Description: #{application.applicant_description}")
  end

  # As a visitor
    # When I visit an admin application show page ('/admin/applications/:id')
    # For every pet that the application is for, I see a button to approve the application for that specific pet
    # When I click that button
    # Then I'm taken back to the admin application show page
    # And next to the pet that I approved, I do not see a button to approve this pet
    # And instead I see an indicator next to the pet that they have been approved
  it 'can approve and reject pets on a pending application' do
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
      status: 'Pending')

    shelter.pets.all.each do |pet|
      application.pets << pet
      PetApplication.update_application_status(application.id, pet.id, 'Pending Review')
    end

    visit "/admin/applications/#{application.id}"
    # save_and_open_page

    expect(page).to_not have_button('Submit Application')
    expect(page).to have_content("Applicant Description: #{application.applicant_description}")
    expect(page).to have_content("Admin Approval for Applicant: #{application.applicant_fullname}")

    expect(page).to have_button("Approve #{application.pets.first.name}")
    expect(page).to have_button("Reject #{application.pets.first.name}")
    expect(page).to have_button("Approve #{application.pets.last.name}")
    expect(page).to have_button("Reject #{application.pets.last.name}")

    within "#pet-#{application.pets.first.id}" do
      expect(page).to have_link("#{application.pets.first.name}")
      expect(page).to have_content("Current Status: Pending Review")
    end

    within "#pet-#{application.pets.last.id}" do
      expect(page).to have_link("#{application.pets.last.name}")
      expect(page).to have_content("Current Status: Pending Review")
    end

    click_on("Approve #{application.pets.first.name}")
    click_on("Reject #{application.pets.last.name}")

    expect(current_path).to eq("/admin/applications/#{application.id}")

    visit "/admin/applications/#{application.id}"
    # save_and_open_page

    expect(page).to_not have_button("Approve #{application.pets.first.name}")
    expect(page).to_not have_button("Reject #{application.pets.first.name}")
    expect(page).to_not have_button("Approve #{application.pets.last.name}")
    expect(page).to_not have_button("Reject #{application.pets.last.name}")

    within "#pet-#{application.pets.first.id}" do
      expect(page).to have_link("#{application.pets.first.name}")
      expect(page).to have_content("Current Status: Approved")
    end

    within "#pet-#{application.pets.last.id}" do
      expect(page).to have_link("#{application.pets.last.name}")
      expect(page).to have_content("Current Status: Rejected")
    end
  end

  # As a visitor
    # When there are two applications in the system for the same pet
    # When I visit the admin application show page for one of the applications
    # And I approve or reject the pet for that application
    # When I visit the other application's admin show page
    # Then I do not see that the pet has been accepted or rejected for that application
    # And instead I see buttons to approve or reject the pet for this specific application
  it 'pet approval status on a pending application does not effect another application with the same pet' do
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

    shelter.pets.all.each do |pet|
      application_1.pets << pet
      application_2.pets << pet
      PetApplication.update_application_status(application_1.id, pet.id, 'Pending Review')
      PetApplication.update_application_status(application_2.id, pet.id, 'Pending Review')
    end

    visit "/admin/applications/#{application_1.id}"
    # save_and_open_page

    expect(page).to_not have_button('Submit Application')
    expect(page).to have_content("Applicant Description: #{application_1.applicant_description}")
    expect(page).to have_content("Admin Approval for Applicant: #{application_1.applicant_fullname}")

    expect(page).to have_button("Approve #{application_1.pets.first.name}")
    expect(page).to have_button("Reject #{application_1.pets.first.name}")
    expect(page).to have_button("Approve #{application_1.pets.last.name}")
    expect(page).to have_button("Reject #{application_1.pets.last.name}")

    within "#pet-#{application_1.pets.first.id}" do
      expect(page).to have_link("#{application_1.pets.first.name}")
      expect(page).to have_content("Current Status: Pending Review")
    end

    within "#pet-#{application_1.pets.last.id}" do
      expect(page).to have_link("#{application_1.pets.last.name}")
      expect(page).to have_content("Current Status: Pending Review")
    end

    click_on("Approve #{application_1.pets.first.name}")
    click_on("Reject #{application_1.pets.last.name}")

    expect(current_path).to eq("/admin/applications/#{application_1.id}")

    visit "/admin/applications/#{application_1.id}"
    # save_and_open_page

    expect(page).to_not have_button("Approve #{application_1.pets.first.name}")
    expect(page).to_not have_button("Reject #{application_1.pets.first.name}")
    expect(page).to_not have_button("Approve #{application_1.pets.last.name}")
    expect(page).to_not have_button("Reject #{application_1.pets.last.name}")

    within "#pet-#{application_1.pets.first.id}" do
      expect(page).to have_link("#{application_1.pets.first.name}")
      expect(page).to have_content("Current Status: Approved")
    end

    within "#pet-#{application_1.pets.last.id}" do
      expect(page).to have_link("#{application_1.pets.last.name}")
      expect(page).to have_content("Current Status: Rejected")
    end

    visit "/admin/applications/#{application_2.id}"
    # save_and_open_page

    expect(page).to_not have_button('Submit Application')
    expect(page).to have_content("Applicant Description: #{application_2.applicant_description}")
    expect(page).to have_content("Admin Approval for Applicant: #{application_2.applicant_fullname}")

    expect(page).to have_button("Approve #{application_2.pets.first.name}")
    expect(page).to have_button("Reject #{application_2.pets.first.name}")
    expect(page).to have_button("Approve #{application_2.pets.last.name}")
    expect(page).to have_button("Reject #{application_2.pets.last.name}")

    within "#pet-#{application_2.pets.first.id}" do
      expect(page).to have_link("#{application_2.pets.first.name}")
      expect(page).to have_content("Current Status: Pending Review")
    end

    within "#pet-#{application_2.pets.last.id}" do
      expect(page).to have_link("#{application_2.pets.last.name}")
      expect(page).to have_content("Current Status: Pending Review")
    end
  end

end
