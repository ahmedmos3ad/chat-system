# frozen_string_literal: true

module API::V1::ResponseHelper
  def render_response(status: :ok, data: {})
    logger.info("Rendering response with status: #{status}, data: #{data.inspect}")
    response_hash = {status: Rack::Utils.status_code(status), data: data}
    respond_to do |format|
      format.json { render json: response_hash, status: status }
      format.xml { render xml: response_hash.to_xml, status: status }
    end
  end

  def render_error(error: "", message: "", status: :unprocessable_entity, data: {}, backtrace: nil, error_type: nil, unhandled: false)
    response = {status: Rack::Utils.status_code(status), error: error, message: message}
    response[:data] = data if data.present?
    response[:exception_type] = error_type if error_type.present?
    response[:unhandled_exception] = true if unhandled
    response[:backtrace] = backtrace if backtrace.present?
    respond_to do |format|
      format.json { render json: response, status: status }
      format.xml { render xml: response.to_xml, status: status }
    end
  end

  def render_bad_request_response(message: I18n.t("errors.bad_request"), error: "BAD_REQUEST", status: :bad_request, invalid_parameter: nil, allowed_values: nil)
    response = {status: 400, error: error, message: message}
    response[:invalid_parameter] = invalid_parameter if invalid_parameter.present?
    response[:allowed_values] = allowed_values if allowed_values.present?
    respond_to do |format|
      format.json { render json: response, status: status }
      format.xml { render xml: response.to_xml, status: status }
    end
  end
end
