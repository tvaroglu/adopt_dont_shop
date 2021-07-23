class PetApplicationsController < ApplicationController

  def review
    application = Application.find(params[:id])
    if application.status == 'Invalid'
      PetApplication.update_application_status(params[:id], params[:pet_id], 'Rejected')
    else
      PetApplication.update_application_status(params[:id], params[:pet_id], params[:status])
    end
    redirect_to "/admin/applications/#{params[:id]}"
  end

end
