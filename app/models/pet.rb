class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true

  belongs_to :shelter
  has_many :pet_applications, dependent: :delete_all
  has_many :applications, through: :pet_applications

  def shelter_name
    shelter.name
  end

  def self.adoptable
    where(adoptable: true)
  end

  def on_current_application?(application_id)
    self.applications.where(id: application_id).count > 0
  end
end
