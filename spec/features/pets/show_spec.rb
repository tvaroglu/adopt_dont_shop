require 'rails_helper'

RSpec.describe 'the pet show' do
  it "shows the pet and all it's attributes" do
    shelter = Shelter.create!(
      name: 'Mystery Building',
      city: 'Irvine CA',
      foster_program: false,
      rank: 9)
    pet = Pet.create!(
      name: 'Scooby',
      age: 2,
      breed: 'Great Dane',
      adoptable: true,
      shelter_id: shelter.id)

    visit "/pets/#{pet.id}"
    # save_and_open_page

    expect(page).to have_content(pet.name)
    expect(page).to have_content(pet.age)
    expect(page).to have_content('Adoptable: Yes')
    expect(page).to have_content(pet.breed)

    expect(page).to have_link(pet.shelter_name)
    click_on(pet.shelter_name)
    expect(current_path).to eq("/admin/shelters/#{shelter.id}")
  end

  it "allows the user to update a pet" do
    shelter = Shelter.create!(
      name: 'Mystery Building',
      city: 'Irvine CA',
      foster_program: false,
      rank: 9)
    pet = Pet.create!(
      name: 'Scrappy',
      age: 1,
      breed: 'Great Dane',
      adoptable: true,
      shelter_id: shelter.id)

    visit "/pets/#{pet.id}"
    # save_and_open_page

    click_on("Update Pet")
    expect(current_path).to eq("/pets/#{pet.id}/edit")

    fill_in 'Breed', with: 'Test'
    click_on("Save")

    expect(current_path).to eq("/pets/#{pet.id}")
    expect(page).to have_content("Breed: Test")
  end

  it "allows the user to delete a pet" do
    shelter = Shelter.create!(
      name: 'Mystery Building',
      city: 'Irvine CA',
      foster_program: false,
      rank: 9)
    pet = Pet.create!(name: 'Scrappy',
      age: 1,
      breed: 'Great Dane',
      adoptable: true,
      shelter_id: shelter.id)

    visit "/pets/#{pet.id}"

    click_on("Delete Pet")

    expect(page).to have_current_path('/pets')
    expect(page).to_not have_content(pet.name)
  end
end
