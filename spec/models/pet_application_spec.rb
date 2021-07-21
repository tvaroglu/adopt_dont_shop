require 'rails_helper'

RSpec.describe PetApplication, type: :model do
  describe "relationships" do
    it {should belong_to :pet}
    it {should belong_to :application}
  end

  describe "class methods" do
    it 'can #update_application_status independent of Application status' do
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

      application.pets << shelter.pets.all.first
      pet_application = PetApplication.find_by(application_id: application.id)

      expect(pet_application.status).to eq(nil)
      expect(application.status).to eq('Pending')

      PetApplication.update_application_status(application.id, application.pets.first.id, 'Approved')
      pet_application = PetApplication.find_by(application_id: application.id)

      expect(pet_application.status).to eq('Approved')
      expect(application.status).to eq('Pending')
    end
    it 'can return #pet_approval_status independent of Application status' do
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

      application.pets << shelter.pets.all.first
      pet_application = PetApplication.find_by(application_id: application.id)

      expect(pet_application.status).to eq(nil)
      expect(application.status).to eq('Pending')

      PetApplication.update_application_status(application.id, application.pets.first.id, 'Pending Review')

      pet_application = PetApplication.pet_approval_status(application.pets.first.id, application.id)

      expect(pet_application.status).to eq('Pending Review')
      expect(application.status).to eq('Pending')
    end

    it '#pet_approval_status is independent of individual Application statuses' do
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
        status: 'In Progress')

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

      application_1.pets << shelter.pets.all.first
      application_2.pets << shelter.pets.all.first
      pet_application_1 = PetApplication.find_by(application_id: application_1.id)
      pet_application_2 = PetApplication.find_by(application_id: application_2.id)

      expect(pet_application_1.status).to eq(nil)
      expect(pet_application_2.status).to eq(nil)
      expect(application_1.status).to eq('Pending')
      expect(application_2.status).to eq('In Progress')

      PetApplication.update_application_status(application_1.id, application_1.pets.first.id, 'Rejected')
      PetApplication.update_application_status(application_2.id, application_2.pets.first.id, 'Approved')

      expect(
        PetApplication.pet_approval_status(
          shelter.pets.first.id, application_1.id))
          .not_to eq(
            PetApplication.pet_approval_status(
              shelter.pets.first.id, application_1.id))

      expect(application_1.status).to eq('Pending')
      expect(application_2.status).to eq('In Progress')
    end
  end

end
