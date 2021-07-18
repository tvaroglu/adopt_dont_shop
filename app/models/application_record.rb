class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.search(search_params)
    where("name ILIKE ?", "%#{search_params}%")
  end

  def last_updated
    self.updated_at.strftime("%Y-%m-%d")
  end
  
end
