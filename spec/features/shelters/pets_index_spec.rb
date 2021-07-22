require 'rails_helper'

RSpec.describe 'the shelters pets index' do
  before(:each) do
    @shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'Boulder shelter', city: 'Boulder, CO', foster_program: false, rank: 9)
    @pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: @shelter.id)
    @pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter.id)
    @pet_3 = Pet.create(adoptable: true, age: 1, breed: 'domestic shorthair', name: 'Sylvester', shelter_id: @shelter_2.id)
    @pet_4 = Pet.create(adoptable: true, age: 1, breed: 'orange tabby shorthair', name: 'Lasagna', shelter_id: @shelter.id)
  end

  it 'lists all the pets associated with the shelter, with their attributes' do
    visit "/admin/shelters/#{@shelter.id}/pets"

    expect(page).to have_content(@pet_1.name)
    expect(page).to have_content(@pet_1.breed)
    expect(page).to have_content(@pet_1.age)
    expect(page).to have_content(@shelter.name)

    expect(page).to have_content(@pet_2.name)
    expect(page).to have_content(@pet_2.breed)
    expect(page).to have_content(@pet_2.age)
    expect(page).to have_content(@shelter.name)

    expect(page).to_not have_content(@pet_3.name)
    expect(page).to_not have_content(@pet_3.shelter_name)
  end

  it 'displays a button to create a new pet' do
    visit "/admin/shelters/#{@shelter.id}/pets"

    expect(page).to have_button("Create New Pet")
    click_on("Create New Pet")
    expect(page).to have_current_path("/admin/shelters/#{@shelter.id}/pets/new")
  end

  it 'displays a button to edit each pet' do
    visit "/admin/shelters/#{@shelter.id}/pets"
    # save_and_open_page

    within "#pet-#{@pet_1.id}" do
      expect(page).to have_button("Edit Pet")
      click_on("Edit Pet")
      expect(page).to have_current_path("/pets/#{@pet_1.id}/edit")
    end

    visit "/admin/shelters/#{@shelter.id}/pets"
    # save_and_open_page

    within "#pet-#{@pet_2.id}" do
      expect(page).to have_button("Edit Pet")
      click_on("Edit Pet")
      expect(page).to have_current_path("/pets/#{@pet_2.id}/edit")
    end
  end

  it 'displays a link to delete each pet' do
    visit "/admin/shelters/#{@shelter.id}/pets"
    # save_and_open_page

    within "#pet-#{@pet_1.id}" do
      expect(page).to have_button("Delete Pet")
      click_on("Delete Pet")
      expect(current_path).to eq("/pets")
    end
    visit "/pets"
    expect(page).to_not have_content(@pet_1.name)

    visit "/admin/shelters/#{@shelter.id}/pets"
    # save_and_open_page

    within "#pet-#{@pet_2.id}" do
      expect(page).to have_button("Delete Pet")
      click_on("Delete Pet")
      expect(current_path).to eq("/pets")
    end
    visit "/pets"
    expect(page).to_not have_content(@pet_2.name)
  end

  it 'displays a form for a number value' do
    visit "/admin/shelters/#{@shelter.id}/pets"

    expect(page).to have_content("Only display pets with an age of at least...")
    expect(page).to have_select("age")
  end

  it 'only displays records above the given return value' do
    visit "/admin/shelters/#{@shelter.id}/pets"

    find("#age option[value='3']").select_option
    click_button("Filter Pets")
    expect(page).to have_content(@pet_2.name)
    expect(page).to_not have_content(@pet_1.name)
    expect(page).to_not have_content(@pet_3.name)
  end

  it 'allows the user to sort in alphabetical order' do
    visit "/admin/shelters/#{@shelter.id}/pets"

    expect(@pet_1.name).to appear_before(@pet_2.name)
    expect(@pet_2.name).to appear_before(@pet_4.name)

    expect(page).to have_button("Sort Alphabetically")
    click_on("Sort Alphabetically")

    expect(@pet_1.name).to appear_before(@pet_4.name)
    expect(@pet_4.name).to appear_before(@pet_2.name)
  end

  it 'links back to the shelter show page' do
    visit "/admin/shelters/#{@shelter.id}/pets"

    click_on(@shelter.name)

    expect(current_path).to eq("/admin/shelters/#{@shelter.id}")
  end
end
