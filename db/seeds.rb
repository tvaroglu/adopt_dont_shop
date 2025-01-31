# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


PetApplication.destroy_all
Application.destroy_all
Pet.destroy_all
Shelter.destroy_all

# Shelters
shelter_1 = Shelter.create!(
  name: 'Aurora Shelter',
  address: '123 Main St.',
  city: 'Aurora',
  state: 'CO',
  zipcode: '80010',
  foster_program: false,
  rank: 9)
shelter_2 = Shelter.create!(
  name: 'Boulder Shelter',
  address: '45 Broadway Ave',
  city: 'Boulder',
  state: 'CO',
  zipcode: '80302',
  foster_program: false,
  rank: 9)
shelter_3 = Shelter.create!(
  name: 'RGV Animal Shelter',
  address: '1900 N Stemmons Fwy.',
  city: 'Dallas',
  state: 'TX',
  zipcode: '75001',
  foster_program: false,
  rank: 5)
shelter_4 = Shelter.create!(
  name: 'Fancy Pets of Colorado',
  address: '8300 Colfax Ave.',
  city: 'Denver',
  state: 'CO',
  zipcode: '80014',
  foster_program: true,
  rank: 10)

# Pets
shelter_1.pets.create!(
  name: 'Mr. Pirate',
  breed: 'Tuxedo Shorthair',
  age: 5,
  adoptable: true)
shelter_1.pets.create!(
  name: 'Clawdia',
  breed: 'Exotic Shorthair',
  age: 3,
  adoptable: true)
shelter_1.pets.create!(
  name: 'Ann',
  breed: 'Ragdoll',
  age: 3,
  adoptable: false)

shelter_2.pets.create!(
  name: 'Macaroni',
  breed: 'Scottish Fold',
  age: 2,
  adoptable: true)
shelter_2.pets.create!(
  name: 'Dumpling',
  breed: 'Russian Blue',
  age: 6,
  adoptable: true)

shelter_3.pets.create!(
  name: 'Lucille Bald',
  breed: 'Sphynx',
  age: 8,
  adoptable: true)

# Applications
application_1 = Application.create!(
  applicant_fullname: 'John Smith',
  applicant_address: '1200 3rd St.',
  applicant_city: 'Golden',
  applicant_state: 'CO',
  applicant_zipcode: '80401',
  applicant_description: 'I am a good guy',
  status: 'In Progress')
application_2 = Application.create!(
  applicant_fullname: 'Jane Doe',
  applicant_address: '500 Poplar Ave.',
  applicant_city: 'Wheat Ridge',
  applicant_state: 'CO',
  applicant_zipcode: '80401',
  applicant_description: 'I want a kitty!',
  status: 'In Progress')

# # Pet Applications
# shelter_1.pets.all.each do |pet|
#   application_1.pets << pet
# end
#
# shelter_2.pets.all.each do |pet|
#   application_2.pets << pet
# end
