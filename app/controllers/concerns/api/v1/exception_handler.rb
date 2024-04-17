module API::V1::ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :default_error
    rescue_from AppException::BadRequest, with: :bad_request
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_not_valid
    rescue_from AppException::UnprocessableEntity, with: :unprocessable_entity
    rescue_from ActionController::UnknownFormat, with: :not_acceptable
    rescue_from ActionController::MethodNotAllowed, with: :method_not_allowed
    rescue_from ActiveRecord::StatementInvalid, with: :invalid_sql_statement
  end

  private

  WARNING_EXCEPTIONS = {"ActiveRecord::RecordInvalid": true,
    "ActiveRecord::RecordNotFound": true,
    "ActionController::UnknownFormat": true,
    "ActionController::MethodNotAllowed": true,
    "ActionDispatch::Http::Parameters::ParseError": true}.freeze

  SUPPORTED_FORMATS = %w[application/json application/xml].freeze

  def log(e, method)
    log_error_to_console(e)
    log_error_to_sentry(e, method)
  end

  def log_error_to_sentry(exception, method)
    except_logger.info("#{method.to_s.humanize} #{exception.message}")
    except_logger.info("Full trace #{exception.backtrace.join("\n")}")
  end

  def log_error_to_console(exception)
    if exception.class.name.match?("AppException::") || WARNING_EXCEPTIONS[exception.class.name.to_sym]
      logger.warn("#{exception.class.name} (#{exception.message})")
    else
      logger.error("#{exception.class.name} (#{exception.message}):\n\t\t\t\t\t       #{exception.backtrace.take(5).join("\n\t\t\t\t\t       ")}")
    end
  end

  def default_error(e)
    logger.fatal("UNHANDLED EXCEPTION: #{e.class.name}, MESSAGE: #{e.message}")
    logger.fatal("SWALLOWING AND RETURNING INTERNAL SERVER ERROR")
    log(e, __method__)
    internal_server_error(e, unhandled: true)
  end

  def internal_server_error(e, unhandled: false)
    log(e, __method__)
    error = e.respond_to?(:error) ? e.error : e.message
    render_error(error: error,
      message: I18n.t("errors.something_went_wrong"),
      error_type: e.class.name,
      unhandled: unhandled,
      backtrace: e.backtrace.take(5),
      status: :internal_server_error)
  end

  def bad_request(e)
    log(e, __method__)
    error = (e.error.blank? || e.error == "invalid_params") ? "BAD_REQUEST" : e.error
    render_bad_request_response(error: error, message: e.message, invalid_parameter: e.invalid_parameter, allowed_values: e.allowed_values)
  end

  def record_not_found(e)
    log(e, __method__)
    error = e.respond_to?(:error) ? e.error : e.message
    render_error(error: error, message: I18n.t("errors.record_not_found"), status: :not_found)
  end


# refractor the below methods to use render_error if I have time
  def record_not_valid(e)
    log(e, __method__)
    response = {status: 422,
                error: "VALIDATION_FAILED",
                message: e.message,
                record: {is_persisted: !e.record.new_record?, id: e.record.id, type: e.record.class.name.underscore}}
    respond_to do |format|
      format.json { render json: response, status: :unprocessable_entity }
      format.xml { render xml: response.to_xml, status: :unprocessable_entity }
    end
  end

  def not_acceptable(e)
    log(e, __method__)
    render json: {status: 406,
                  error: "NOT_ACCEPTABLE",
                  message: I18n.t("errors.not_acceptable"),
                  supported_formats: SUPPORTED_FORMATS}, status: :not_acceptable
  end

  def method_not_allowed(e)
    log(e, __method__)
    response = {status: 405,
                error: "METHOD_NOT_ALLOWED",
                message: I18n.t("errors.method_not_allowed"),
                allowed_methods: ["GET", "POST", "PUT", "PATCH", "DELETE"]}
    respond_to do |format|
      format.json { render json: response, status: :method_not_allowed }
      format.xml { render xml: response.to_xml, status: :method_not_allowed }
    end
  end

  def invalid_sql_statement(e)
    log(e, __method__)
    response = {status: 500,
                error: e.message,
                message: I18n.t("errors.something_went_wrong"),
                error_type: e.class.name,
                sql_statement: e.sql,
                backtrace: e.backtrace.take(5)}
    respond_to do |format|
      format.json { render json: response, status: :internal_server_error }
      format.xml { render xml: response.to_xml, status: :internal_server_error }
    end
  end

  def except_logger
    Logger.new("#{Rails.root.join("log/exceptions.log")}")
  end
end