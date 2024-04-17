# frozen_string_literal: true

module AppException

  class BaseException < StandardError
    attr_reader :error
    attr_reader :message

    def initialize(error: "", message: "")
      @message = message.presence || I18n.t("errors.#{error}")
      @error = error
    end
  end


  class BadRequest < BaseException
    attr_reader :invalid_parameter
    attr_reader :allowed_values

    def initialize(error: "", message: "", invalid_parameter: nil, allowed_values: nil)
      super(error: error, message: message)
      @invalid_parameter = invalid_parameter
      @allowed_values = allowed_values
    end
  end


  class UnprocessableEntity < BaseException; end

end
