# frozen_string_literal: true

class API::V1::ApplicationsController < API::V1::BaseController

  before_action :set_current_application, only: %i[show update destroy]

  def create
    logger.info("Creating application with params: #{application_params}")
    application = Application.new(application_params)
    application.save!
    logger.info("Application created with id: #{application.id}, token: #{application.token}")
    render_response(data: {application: application.as_serialized_json}, status: :created)
  end

  def index
    logger.info("Fetching applications with page: #{@page} and per_page: #{@per_page}")
    applications = Application.all
    logger.info("Fetched applications successfully")
    render_response(data: {applications: applications.page(@page).per(@per_page).as_serialized_json, pagination_info: {total_count: applications.count, page_number: @page, page_size: @per_page}}, status: :ok)
  end

  def show
    logger.info("Fetched application with token: #{params[:token]}, token: #{@application.token}")
    render_response(data: {application: @application.as_serialized_json}, status: :ok)
  end

  def update
    logger.info("Updating application with params: #{application_params}")
    @application.update!(application_params)
    logger.info("Application with id: #{@application.id} updated")
    render_response(data: {application: @application.as_serialized_json}, status: :ok)
  end

  def destroy
    logger.info("Destroying application with id: #{@application.id}, token: #{@application.token}")
    @application.destroy!
    logger.info("Application with id: #{@application.id} destroyed")
    head :no_content
  end

  private

  def application_params
    params.require(:application).permit(:name)
  end
end
