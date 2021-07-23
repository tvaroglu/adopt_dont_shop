require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it { should have_many :pet_applications}
    it {should have_many(:pets).through(:pet_applications)}
  end

  describe 'validations' do
    it { should validate_presence_of(:applicant_fullname) }
    it { should validate_presence_of(:applicant_address) }
    it { should validate_presence_of(:applicant_city) }
    it { should validate_presence_of(:applicant_state) }
    it { should validate_presence_of(:applicant_zipcode) }
  end


  describe 'instance methods' do
    it 'can return #last_updated date' do
      application = Application.create!(
        applicant_fullname: 'John Smith',
        applicant_address: '1200 3rd St.',
        applicant_city: 'Golden',
        applicant_state: 'CO',
        applicant_zipcode: '80401',
        applicant_description: 'I am a good guy',
        status: 'In Progress')

      expect(application.last_updated).to eq(application.updated_at.strftime("%Y-%m-%d"))
    end

    it 'can return #full_address' do
      application = Application.create!(
        applicant_fullname: 'John Smith',
        applicant_address: '1200 3rd St.',
        applicant_city: 'Golden',
        applicant_state: 'CO',
        applicant_zipcode: '80401',
        applicant_description: 'I am a good guy',
        status: 'In Progress')

      expect(application.full_address).to eq(
        "1200 3rd St., Golden, CO 80401")
    end

    it 'can determine if an application #has_pets?' do
      application = Application.create!(
        applicant_fullname: 'John Smith',
        applicant_address: '1200 3rd St.',
        applicant_city: 'Golden',
        applicant_state: 'CO',
        applicant_zipcode: '80401',
        applicant_description: 'I am a good guy',
        status: 'In Progress')
      expect(application.has_pets?).to be false

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
      expect(application.has_pets?).to be true
    end

    it 'can determine if an application has #adopted_pets' do
      application = Application.create!(
        applicant_fullname: 'John Smith',
        applicant_address: '1200 3rd St.',
        applicant_city: 'Golden',
        applicant_state: 'CO',
        applicant_zipcode: '80401',
        applicant_description: 'I am a good guy',
        status: 'In Progress')

      expect(application.has_pets?).to be false
      expect(application.adopted_pets.count).to eq(0)

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
        adoptable: false)

      application.pets << shelter.pets.all.first
      expect(application.has_pets?).to be true
      expect(application.adopted_pets.count).to eq(1)
    end
  end


end
