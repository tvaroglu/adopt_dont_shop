class PetApplication < ApplicationRecord
  belongs_to :pet
  belongs_to :application

  def self.update_application_status(app_id, new_status)
    application = PetApplication.find_by(application_id: app_id)
    application.update(status: new_status)
  end

  def self.update_pet_approval_status(pet_id, new_status)
    application = PetApplication.find_by(pet_id: pet_id)
    application.update(status: new_status)
  end

  def self.pet_approval_status(pet_id, application_id)
    self.select(:status)
    .where(pet_id: pet_id)
    .where(application_id: application_id)
    # .where.not(status: 'Approved', status: 'Rejected')
    .first
  end

end
