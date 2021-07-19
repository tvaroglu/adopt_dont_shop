class ApplicationsController < ApplicationController

  def show
    @application = Application.find(params[:id])
    @pets = @application.pets.all
  end

  def new
  end

  def create
    application = Application.new(application_params)
    if application.save
      redirect_to "/admin/applications/#{application.id}"
    else
      redirect_to '/admin/applications/new'
      flash[:alert] = "Error: #{error_message(application.errors)}"
    end
  end

  def search
    @application = Application.find(params[:id])
    @pets = Pet.search(params[:search])
  end

  def add_pets
    @application = Application.find(params[:id])
    @pet = Pet.find(params[:pet_id])
    @application.pets << @pet
    redirect_to "/admin/applications/#{@application.id}"
  end

  private
  def application_params
    params.permit(:id, :applicant_fullname, :applicant_address, :applicant_city, :applicant_state, :applicant_zipcode, :applicant_description, :status)
  end

  private
  def pet_params
    params.permit(:id, :name, :age, :breed, :adoptable, :shelter_id)
  end

end
