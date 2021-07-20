require 'rails_helper'

RSpec.describe 'the shelter show' do
  # As a visitor
  #   When I visit an admin shelter show page
  #   Then I see that shelter's name and full address
  it "shows the shelter name it's full address info" do
    shelter = Shelter.create!(
      name: 'Aurora Shelter',
      address: '1200 Cedar Ct.',
      city: 'Aurora',
      state: 'CO',
      zipcode: '80010',
      foster_program: false,
      rank: 9)

    visit "/admin/shelters/#{shelter.id}"
    # save_and_open_page

    full_address = "#{shelter.address}, #{shelter.city}, #{shelter.state} #{shelter.zipcode}"

    expect(page).to have_content(shelter.name)
    expect(page).to have_content("Address: #{full_address}")
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
    click_on("View All Pets At: #{shelter.name}")

    expect(page).to have_current_path("/admin/shelters/#{shelter.id}/pets")
  end
end
