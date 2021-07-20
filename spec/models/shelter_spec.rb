require 'rails_helper'

RSpec.describe Shelter, type: :model do
  describe 'relationships' do
    it { should have_many(:pets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:rank) }
    it { should validate_numericality_of(:rank) }
  end

  before(:each) do
    @shelter_1 = Shelter.create!(
      name: 'Aurora Shelter',
      address: '1200 Cedar Ct.',
      city: 'Aurora',
      state: 'CO',
      zipcode: '80010',
      foster_program: false,
      rank: 9)
    @shelter_2 = Shelter.create!(
      name: 'RGV Animal Shelter',
      address: '1900 N Stemmons Fwy.',
      city: 'Dallas',
      state: 'TX',
      zipcode: '75001',
      foster_program: false,
      rank: 5)
    @shelter_3 = Shelter.create!(
      name: 'Fancy Pets of Colorado',
      address: '8300 Colfax Ave.',
      city: 'Denver',
      state: 'CO',
      zipcode: '80014',
      foster_program: true,
      rank: 10)

    @pet_1 = @shelter_1.pets.create!(
      name: 'Mr. Pirate',
      breed: 'Tuxedo Shorthair',
      age: 5,
      adoptable: false)
    @pet_2 = @shelter_1.pets.create!(
      name: 'Clawdia',
      breed: 'Exotic Shorthair',
      age: 3,
      adoptable: true)
    @pet_3 = @shelter_3.pets.create!(
      name: 'Lucille Bald',
      breed: 'Sphynx',
      age: 8,
      adoptable: true)
    @pet_4 = @shelter_1.pets.create!(
      name: 'Ann',
      breed: 'Ragdoll',
      age: 5,
      adoptable: true)
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Shelter.search("Fancy")).to eq([@shelter_3])
      end
    end

    describe '#order_by_recently_created' do
      it 'returns shelters with the most recently created first' do
        expect(Shelter.order_by_recently_created).to eq([@shelter_3, @shelter_2, @shelter_1])
      end
    end

    describe '#order_by_number_of_pets' do
      it 'orders the shelters by number of pets they have, descending' do
        expect(Shelter.order_by_number_of_pets).to eq([@shelter_1, @shelter_3, @shelter_2])
      end
    end

    describe '#order_by_name_desc' do
      it 'orders the shelters by name in reverse alphabetical order' do
        expected = Shelter.order_by_name_desc

        expect(expected.length).to eq(3)
        expect(expected).to eq([@shelter_2, @shelter_3, @shelter_1])
      end
    end

    describe '#pending_applications' do
      it 'can return shelters with pending applications' do
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

        shelter_1 = Shelter.create!(
          name: 'Aurora Shelter',
          address: '123 Main St.',
          city: 'Aurora',
          state: 'CO',
          zipcode: '80010',
          foster_program: false,
          rank: 9)
        shelter_1.pets.create!(
          name: 'Mr. Pirate',
          breed: 'Tuxedo Shorthair',
          age: 5,
          adoptable: true)

        application_1.pets << shelter_1.pets.all.last
        application_2.pets << shelter_1.pets.all.last

        expected = Shelter.pending_applications

        expect(expected.length).to eq(1)
        expect(expected.first.name).to eq(shelter_1.name)
        expect(expected.last.name).to eq(shelter_1.name)
      end
    end
  end

  describe 'instance methods' do
    describe '.adoptable_pets' do
      it 'only returns pets that are adoptable' do
        expect(@shelter_1.adoptable_pets).to eq([@pet_2, @pet_4])
      end
    end

    describe '.alphabetical_pets' do
      it 'returns pets associated with the given shelter in alphabetical name order' do
        expect(@shelter_1.alphabetical_pets).to eq([@pet_4, @pet_2])
      end
    end

    describe '.shelter_pets_filtered_by_age' do
      it 'filters the shelter pets based on given params' do
        expect(@shelter_1.shelter_pets_filtered_by_age(5)).to eq([@pet_4])
      end
    end

    describe '.pet_count' do
      it 'returns the number of pets at the given shelter' do
        expect(@shelter_1.pet_count).to eq(3)
      end
    end

    describe '.shelter_info' do
      it 'returns the name and address of a given shelter' do
        expected = @shelter_1.shelter_info(@shelter_1.id)

        expect(expected.name).to eq(@shelter_1.name)
        expect(expected.address).to eq(@shelter_1.address)
        expect(expected.city).to eq(@shelter_1.city)
        expect(expected.state).to eq(@shelter_1.state)
        expect(expected.zipcode).to eq(@shelter_1.zipcode)
      end
    end

    describe '.average_pet_age' do
      it 'returns the average pet age of all pets at a given shelter' do
        expect(@shelter_1.average_pet_age.to_f).to eq((@pet_1.age + @pet_2.age + @pet_4.age) / 3.to_f)
      end
    end
  end

end
