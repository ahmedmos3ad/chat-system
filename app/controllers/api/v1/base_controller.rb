# frozen_string_literal: true

class API::V1::BaseController < ApplicationController

  MAX_PAGE_SIZE = 100 # arbitrary value should be set based on the application requirements

  include API::V1::ResponseHelper
  include API::V1::ExceptionHandler
  include API::V1::LookupSetters

  before_action :set_time_zone
  around_action :use_time_zone
  before_action :validate_request_format
  before_action :set_paging_parameters, only: %i[index]

  def logger
    @logger ||= ConsoleLogger.instance.logger
  end

  def validate_request_format
    request.format = :json if request.format.html? # default to json
    raise ActionController::UnknownFormat unless request.format.json? || request.format.xml? || request.format == Mime::ALL
  end

  def set_time_zone
    @time_zone = if request.headers["Timezone"].present? && ActiveSupport::TimeZone[request.headers["Timezone"].to_s].present?
      request.headers["Timezone"].to_s
    else
      "UTC"
    end
  end

  def use_time_zone(&)
    Time.use_zone(@time_zone, &)
  end

  def set_paging_parameters
    @page = 1
    @per_page = 10
    @per_page = params[:page_size].to_i if params[:page_size].present?
    @page = params[:page_number].to_i if params[:page_number].present?
    raise AppException::BadRequest.new(message: "Invalid page size", invalid_parameter: "page_size", allowed_values: "1..#{MAX_PAGE_SIZE}") if @per_page >= MAX_PAGE_SIZE || @per_page <= 0
    raise AppException::BadRequest.new(message: "Invalid page number", invalid_parameter: "page_number") if @page <= 0
  end
end
