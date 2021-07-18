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

  private
  def application_params
    params.permit(:id, :applicant_fullname, :applicant_address, :applicant_city, :applicant_state, :applicant_zipcode, :applicant_description, :status)
  end

end
