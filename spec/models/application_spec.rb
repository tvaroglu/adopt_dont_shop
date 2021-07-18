require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it { should have_many :pet_applications}
    it {should have_many(:pets).through(:pet_applications)}
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
      allow(Date).to receive(:today).and_return('2021-07-18')

      expect(application.last_updated).to eq(Date.today)
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
  end

end
