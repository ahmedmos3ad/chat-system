# frozen_string_literal: true

class API::V1::BaseController < ApplicationController
  include API::V1::ResponseHelper

  before_action :set_time_zone
  around_action :use_time_zone
  before_action :validate_request_format

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
end
