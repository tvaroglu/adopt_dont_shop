require 'rails_helper'

RSpec.describe 'the new application form' do
# As a visitor
  # When I visit the pet index page
  # Then I see a link to "Start an Application"
  # When I click this link
  # Then I am taken to the new application page where I see a form
  # When I fill in this form with my:
    # Name
    # Street Address
    # City
    # State
    # Zip Code
  # And I click submit
  # Then I am taken to the new application's show page
  # And I see my Name, address information, and description of why I would make a good home
  # And I see an indicator that this application is "In Progress"
  it 'can link to the new application form' do
    shelter = Shelter.create!(
      name: 'Aurora shelter',
      city: 'Aurora, CO',
      foster_program:
      false, rank: 9)
    pet_1 = Pet.create!(
      adoptable: true,
      age: 7,
      breed: 'sphynx',
      name: 'Bare-y Manilow',
      shelter_id: shelter.id)
    pet_2 = Pet.create!(
      adoptable: true,
      age: 3,
      breed: 'domestic pig',
      name: 'Babe',
      shelter_id: shelter.id)
    pet_3 = Pet.create!(
      adoptable: true,
      age: 4,
      breed: 'chihuahua',
      name: 'Elle',
      shelter_id: shelter.id)

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

    visit "/pets"
    # save_and_open_page
    expect(page).to have_button("New Adoption Application")

    click_on("New Adoption Application")
    expect(current_path).to eq('/admin/applications/new')
  end

  describe 'application creation' do
    context 'with valid data' do
      it 'can create a new application from the form' do
        shelter = Shelter.create!(
          name: 'Aurora shelter',
          city: 'Aurora, CO',
          foster_program:
          false, rank: 9)
        pet_1 = Pet.create!(
          adoptable: true,
          age: 7,
          breed: 'sphynx',
          name: 'Bare-y Manilow',
          shelter_id: shelter.id)
        pet_2 = Pet.create!(
          adoptable: true,
          age: 3,
          breed: 'domestic pig',
          name: 'Babe',
          shelter_id: shelter.id)
        pet_3 = Pet.create!(
          adoptable: true,
          age: 4,
          breed: 'chihuahua',
          name: 'Elle',
          shelter_id: shelter.id)

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

        visit '/admin/applications/new'
        # save_and_open_page

        fill_in 'Full Name:', with: application.applicant_fullname
        fill_in 'Street Address:', with: application.applicant_address
        fill_in 'City:', with: application.applicant_city
        fill_in 'State:', with: application.applicant_state
        fill_in 'Zip Code:', with: application.applicant_zipcode
        fill_in 'Why you would make a good home for this pet:', with: application.applicant_description
        click_button 'Save'

        expect(current_path).to eq("/admin/applications/#{application.id.to_i + 1}")

        expect(page).to have_content(application.applicant_fullname)
        expect(page).to have_content(application.full_address)
        expect(page).to have_content(application.applicant_description)
        expect(page).to have_content(application.status)
      end
    end
    context 'with invalid data' do
    # As a visitor
      # When I visit the new application page
      # And I fail to fill in any of the form fields
      # And I click submit
      # Then I am taken back to the new applications page
      # And I see a message that I must fill in those fields.
      it 'cannot create a new application from the form' do
        shelter = Shelter.create!(
          name: 'Aurora shelter',
          city: 'Aurora, CO',
          foster_program:
          false, rank: 9)
        pet_1 = Pet.create!(
          adoptable: true,
          age: 7,
          breed: 'sphynx',
          name: 'Bare-y Manilow',
          shelter_id: shelter.id)
        pet_2 = Pet.create!(
          adoptable: true,
          age: 3,
          breed: 'domestic pig',
          name: 'Babe',
          shelter_id: shelter.id)
        pet_3 = Pet.create!(
          adoptable: true,
          age: 4,
          breed: 'chihuahua',
          name: 'Elle',
          shelter_id: shelter.id)

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

        visit '/admin/applications/new'
        # save_and_open_page

        fill_in 'Full Name:', with: ''
        fill_in 'Street Address:', with: ''
        fill_in 'City:', with: ''
        fill_in 'State:', with: ''
        fill_in 'Zip Code:', with: ''
        fill_in 'Why you would make a good home for this pet:', with: ''
        click_button 'Save'

        expect(current_path).to eq('/admin/applications/new')

        expect(page).to have_content("Error: Applicant fullname can't be blank, Applicant address can't be blank, Applicant city can't be blank, Applicant state can't be blank, Applicant zipcode can't be blank, Applicant description can't be blank")
      end
    end

  end
end
