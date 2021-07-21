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

      PetApplication.update_application_status(application.id, 'Approved')
      updated_pet_application = PetApplication.find_by(application_id: application.id)

      expect(updated_pet_application.status).to eq('Approved')
      expect(application.status).to eq('Pending')
    end
    it 'can #update_pet_approval_status independent of Application status' do
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

      PetApplication.update_pet_approval_status(application.pets.first.id, 'Rejected')
      updated_pet_application = PetApplication.find_by(application_id: application.id)

      expect(updated_pet_application.status).to eq('Rejected')
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

      PetApplication.update_pet_approval_status(application.pets.first.id, 'Pending Review')

      pet_application = PetApplication.pet_approval_status(application.pets.first.id, application.id)

      expect(pet_application.status).to eq('Pending Review')
      expect(application.status).to eq('Pending')
    end
  end

end
