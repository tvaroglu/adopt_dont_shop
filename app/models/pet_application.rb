class PetApplication < ApplicationRecord
  belongs_to :pet
  belongs_to :application

  def self.update_application_status(app_id, pet_id, new_status)
    self.where(application_id: app_id, pet_id: pet_id)
    .first
    .update(status: new_status)
  end

  def self.pet_approval_status(pet_id, application_id)
    self.select(:status)
    .where(pet_id: pet_id)
    .where(application_id: application_id)
    .first
  end

end
