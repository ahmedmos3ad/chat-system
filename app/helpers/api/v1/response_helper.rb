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
end
