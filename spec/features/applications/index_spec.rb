require 'rails_helper'

RSpec.describe 'the applications index' do

  ## Custom story (Applications index #36)
  # As a visitor
    # When I visit the admin application index page
    # And I see a link to all applications, the applicant name, created date, and current status
  it 'displays all applications' do
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

    visit "/admin/applications"
    # save_and_open_page

    within "#application-#{application_1.id}" do
      expect(page).to have_content("Created At: #{application_1.created_at}")
      expect(page).to have_content("Current Status: #{application_1.status}")
      expect(page).to have_link("Application: #{application_1.applicant_fullname}")
      click_on("Application: #{application_1.applicant_fullname}")
      expect(current_path).to eq("/admin/applications/#{application_1.id}")
    end

    visit "/admin/applications"
    # save_and_open_page

    within "#application-#{application_2.id}" do
      expect(page).to have_content("Created At: #{application_2.created_at}")
      expect(page).to have_content("Current Status: #{application_2.status}")
      expect(page).to have_link("Application: #{application_2.applicant_fullname}")
      click_on("Application: #{application_2.applicant_fullname}")
      expect(current_path).to eq("/admin/applications/#{application_2.id}")
    end
  end

end
