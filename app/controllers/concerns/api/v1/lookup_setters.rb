module API::V1::LookupSetters
  extend ActiveSupport::Concern

  private

  def set_current_application
    @application = Application.find_by!(token: params[:token])
  end
end