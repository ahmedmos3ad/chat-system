# frozen_string_literal: true

class API::V1::ApplicationsController < API::V1::BaseController
  def create
    logger.info("Creating application with params: #{application_params}")
    application = Application.new(application_params)
    application.save!
    logger.info("Application created with id: #{application.id}")
    render_response(data: {application: application.as_serialized_json}, status: :created)
  end

  private

  def application_params
    params.require(:application).permit(:name)
  end
end
