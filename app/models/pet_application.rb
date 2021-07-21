class PetApplication < ApplicationRecord
  belongs_to :pet
  belongs_to :application

  def self.update_application_status(app_id, pet_id, new_status)
    where(application_id: app_id, pet_id: pet_id)
    .first
    .update(status: new_status)
    self.reject(app_id) if new_status == 'Rejected'
  end

  def self.reject(app_id)
    Application.find_by(id: app_id)
    .update(status: 'Rejected')
  end

  def self.pet_approval_status(pet_id, application_id)
    select(:status)
    .where(pet_id: pet_id, application_id: application_id)
    .first
  end

end
