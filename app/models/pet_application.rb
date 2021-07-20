class PetApplication < ApplicationRecord
  belongs_to :pet
  belongs_to :application

  def self.update_status(id, new_status)
    application = PetApplication.find(id)
    application.update(status: new_status)
  end

end
