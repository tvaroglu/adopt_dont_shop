class PetApplication < ApplicationRecord
  belongs_to :pet
  belongs_to :application

  def self.update_application_status(app_id, pet_id, new_status)
    where(application_id: app_id, pet_id: pet_id)
    .first
    .update(status: new_status)
    if new_status == 'Rejected'
      reject(app_id)
    elsif total_pet_count(app_id) == approved_pet_count(app_id)
      approve(app_id)
      Pet.update_adoption_status(app_id)
    end
  end
  # callback method can run before or after control action for custom methods
    # (i.e. to set default column value)
    # typically used to check session data
  # this would go in a controller action within the PetApplication controller

  def self.reject(app_id)
    Application.find_by(id: app_id)
    .update(status: 'Rejected')
  end

  def self.approve(app_id)
    Application.find_by(id: app_id)
    .update(status: 'Approved')
  end

  def self.pet_approval_status(pet_id, application_id)
    select(:status)
    .where(pet_id: pet_id, application_id: application_id)
    .first
    .status
  end

  def self.total_pet_count(app_id)
    joins(:application)
    .where(application_id: app_id)
    .count
  end

  def self.approved_pet_count(app_id)
    joins(:application)
    .where(application_id: app_id, status: 'Approved')
    .count
  end

end
