RSpec.describe 'the application rejection' do
  # As a visitor
  #   When I visit an admin application show page
  #   And I reject one or more pets for the application
  #   And I approve all other pets on the application
  #   Then I am taken back to the admin application show page
  #   And I see the application's status has changed to "Rejected"
  it 'can reject an entire application by rejecting a pet' do
    application = Application.create!(
      applicant_fullname: 'John Smith',
      applicant_address: '1200 3rd St.',
      applicant_city: 'Golden',
      applicant_state: 'CO',
      applicant_zipcode: '80401',
      applicant_description: 'I am a good guy',
      status: 'Pending')

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
      name: 'Macaroni',
      breed: 'Scottish Fold',
      age: 2,
      adoptable: true)

    application.pets << shelter.pets.all.first
    application.pets << shelter.pets.all.last

    PetApplication.update_application_status(application.id, application.pets.first.id, 'Pending Review')
    PetApplication.update_application_status(application.id, application.pets.last.id, 'Pending Review')

    visit "/admin/applications/#{application.id}"
    # save_and_open_page

    click_on("Approve #{application.pets.first.name}")
    click_on("Reject #{application.pets.last.name}")

    expect(current_path).to eq("/admin/applications/#{application.id}")

    visit "/admin/applications/#{application.id}"
    # save_and_open_page

    expect(page).to have_content("Application Status: Rejected")
  end

  # As a visitor
    # When a pet has an "Approved" application on them
    # And when the pet has a "Pending" application on them
    # And I visit the admin application show page for the pending application
    # Then next to the pet I do not see a button to approve them
    # And instead I see a message that this pet has been approved for adoption
    # And I do see a button to reject them
  it "can't approve a pet if it's already been approved on another application" do
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
      status: 'Approved')
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
      PetApplication.update_application_status(application_1.id, pet.id, 'Approved')
      PetApplication.update_application_status(application_1.id, pet.id, 'Approved')
      PetApplication.update_application_status(application_2.id, pet.id, 'Pending Review')
      PetApplication.update_application_status(application_2.id, pet.id, 'Pending Review')
    end

    visit "/admin/applications/#{application_2.id}"
    # save_and_open_page
    expect(Application.find(application_2.id).status).to eq('Pending')

    within "#pet-approval-#{application_2.pets.first.id}" do
      expect(page).to have_content("Alert: #{application_2.pets.first.name} Already Approved for Adoption on Another Application")
      expect(page).to_not have_button("Approve #{application_2.pets.first.name}")
      expect(page).to have_button("Reject #{application_2.pets.first.name}")
    end

    within "#pet-approval-#{application_2.pets.last.id}" do
      expect(page).to have_content("Alert: #{application_2.pets.last.name} Already Approved for Adoption on Another Application")
      expect(page).to_not have_button("Approve #{application_2.pets.last.name}")
      expect(page).to have_button("Reject #{application_2.pets.last.name}")
    end
  end

end
