class Application < ApplicationRecord
  has_many :pet_applications
  has_many :pets, through: :pet_applications

  def full_address
    "#{self.applicant_address}, #{self.applicant_city}, #{self.applicant_state} #{self.applicant_zipcode}"
  end
end
