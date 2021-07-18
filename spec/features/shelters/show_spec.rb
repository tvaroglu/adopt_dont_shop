require 'rails_helper'

RSpec.describe 'the shelter show' do
  it "shows the shelter and all it's attributes" do
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

    visit "/admin/shelters/#{shelter.id}"

    expect(page).to have_content(shelter.name)
    expect(page).to have_content(shelter.rank)
    expect(page).to have_content(shelter.city)
  end

  it "shows the number of pets associated with the shelter" do
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    shelter.pets.create(name: 'garfield', breed: 'shorthair', adoptable: true, age: 1)

    visit "/admin/shelters/#{shelter.id}"

    within ".pet-count" do
      expect(page).to have_content(shelter.pets.count)
    end
  end

  it "allows the user to delete a shelter" do
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

    visit "/admin/shelters/#{shelter.id}"

    click_on("Delete: #{shelter.name}")

    expect(page).to have_current_path('/admin/shelters')
    expect(page).to_not have_content(shelter.name)
  end

  it 'displays a link to the shelters pets index' do
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: true, rank: 9)

    visit "/admin/shelters/#{shelter.id}"

    expect(page).to have_button("View All Pets At: #{shelter.name}")
    click_on("All Pets At: #{shelter.name}")

    expect(page).to have_current_path("/admin/shelters/#{shelter.id}/pets")
  end
end
