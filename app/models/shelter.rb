class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy

  def self.order_by_name_desc
    find_by_sql("SELECT * FROM shelters ORDER BY name DESC")
  end

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def self.pending_applications
    joins(pets: :applications)
    .where({applications: {status: 'Pending'}})
    .group(:id)
    .order(:name)
  end

  def has_pending_applications?(shelter_id)
    Shelter.pending_applications
    .where(id: shelter_id)
    .length > 0
  end

  def pets_pending_approval(shelter_id)
    Shelter.joins(pets: :applications)
    .select("pets.name","applications.id")
    .where(id: shelter_id)
    .where({applications: {status: 'Pending'}})
  end

  def adopted_pets(shelter_id)
    Shelter.joins(pets: :applications)
    .where({applications: {status: 'Approved'}})
    .where({pets: {adoptable: false}})
  end

  def shelter_info(shelter_id)
    Shelter.find_by_sql(
      "SELECT name, address, city, state, zipcode FROM shelters WHERE id = #{shelter_id}"
    ).first
  end

  def average_pet_age
    pets.average(:age)
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

end
