class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true

  belongs_to :shelter
  has_many :pet_applications, dependent: :delete_all
  has_many :applications, through: :pet_applications

  def self.adoptable
    where(adoptable: true)
  end

  def self.update_adoption_status(app_id)
    joins(:applications)
    .joins(:pet_applications)
    .where({applications: {status: 'Approved'}})
    .where({pet_applications: {application_id: app_id}})
    .update_all(adoptable: false)
  end

  def on_current_application?(application_id)
    self.applications.where(id: application_id).count > 0
  end

  def shelter_name
    shelter.name
  end

end
