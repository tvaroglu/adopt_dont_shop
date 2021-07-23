class PetApplicationsController < ApplicationController

  def review
    PetApplication.update_application_status(params[:id], params[:pet_id], params[:status])
    redirect_to "/admin/applications/#{params[:id]}"
  end

end
