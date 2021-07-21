class SheltersController < ApplicationController

  def index
    if params[:sort] == "pet_count"
      @shelters = Shelter.order_by_number_of_pets
    elsif params[:search].present?
      @shelters = Shelter.search(params[:search])
    else
      # @shelters = Shelter.order_by_recently_created
      @shelters = Shelter.order_by_name_desc
    end
    @shelters_pending_app_approvals = Shelter.pending_applications
  end

  def pets
    @shelter = Shelter.find(params[:shelter_id])
    if params[:sort] == 'alphabetical'
      @shelter_pets = @shelter.alphabetical_pets
    elsif params[:age]
      @shelter_pets = @shelter.shelter_pets_filtered_by_age(params[:age])
    else
      @shelter_pets = @shelter.adoptable_pets
    end
  end

  def show
    @shelter = Shelter.find(params[:id])
    @full_address = @shelter.shelter_info(params[:id])
  end

  def new
  end

  def create
    shelter = Shelter.new(shelter_params)
    if shelter.save
      redirect_to '/admin/shelters'
    else
      redirect_to '/admin/shelters/new'
      flash[:alert] = "Error: #{error_message(shelter.errors)}"
    end
  end

  def edit
    @shelter = Shelter.find(params[:id])
  end

  def update
    shelter = Shelter.find(shelter_params[:id])
    if shelter.update(shelter_params)
      redirect_to '/admin/shelters'
    else
      redirect_to "/admin/shelters/#{shelter.id}/edit"
      flash[:alert] = "Error: #{error_message(shelter.errors)}"
    end
  end

  def destroy
    shelter = Shelter.find(params[:id])
    # shelter.pets.destroy_all
    shelter.destroy
    redirect_to '/admin/shelters'
  end

  private
  def shelter_params
    params.permit(:id, :name, :city, :foster_program, :rank)
  end

end
