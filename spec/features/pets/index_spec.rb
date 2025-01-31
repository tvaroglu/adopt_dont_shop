require 'rails_helper'

RSpec.describe 'the pets index' do
  it 'lists all the pets with their attributes' do
    shelter = Shelter.create!(
      name: 'Aurora shelter',
      city: 'Aurora, CO',
      foster_program: false,
      rank: 9)
    pet_1 = Pet.create!(adoptable: true,
      age: 1,
      breed: 'sphynx',
      name: 'Lucille Bald',
      shelter_id: shelter.id)
    pet_2 = Pet.create!(adoptable: true,
      age: 3,
      breed: 'doberman',
      name: 'Lobster',
      shelter_id: shelter.id)

    visit "/pets"
    # save_and_open_page

    expect(page).to have_content(pet_1.name)
    expect(page).to have_content(pet_1.breed)
    expect(page).to have_content(pet_1.age)
    expect(page).to have_content(shelter.name)

    expect(page).to have_content(pet_2.name)
    expect(page).to have_content(pet_2.breed)
    expect(page).to have_content(pet_2.age)
    expect(page).to have_content(shelter.name)
  end

  it 'only lists adoptable pets' do
    shelter = Shelter.create!(
      name: 'Aurora shelter',
      city: 'Aurora, CO',
      foster_program: false,
      rank: 9)
    pet_1 = Pet.create!(
      adoptable: true,
      age: 1,
      breed: 'sphynx',
      name: 'Lucille Bald',
      shelter_id: shelter.id)
    pet_2 = Pet.create!(
      adoptable: true,
      age: 3,
      breed: 'doberman',
      name: 'Lobster',
      shelter_id: shelter.id)
    pet_3 = Pet.create!(
      adoptable: false,
      age: 2,
      breed: 'saint bernard',
      name: 'Beethoven',
      shelter_id: shelter.id)

    visit "/pets"
    # save_and_open_page

    expect(page).to_not have_content(pet_3.name)
  end

  it 'has a text box to filter results by keyword' do
    visit "/pets"
    # save_and_open_page

    expect(page).to have_button("Search")
  end

  it 'lists partial matches as search results' do
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

    visit "/pets"
    # save_and_open_page

    fill_in 'Search', with: "Ba"
    click_on("Search")

    expect(page).to have_content(pet_1.name)
    expect(page).to have_content(pet_2.name)
    expect(page).to_not have_content(pet_3.name)
  end

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
  end
end
