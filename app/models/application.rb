class Application < ApplicationRecord
  validates :applicant_fullname, presence: true
  validates :applicant_address, presence: true
  validates :applicant_city, presence: true
  validates :applicant_state, presence: true
  validates :applicant_zipcode, presence: true
  validates :applicant_description, presence: true

  has_many :pet_applications
  has_many :pets, through: :pet_applications

  def full_address
    "#{self.applicant_address}, #{self.applicant_city}, #{self.applicant_state} #{self.applicant_zipcode}"
  end
end
