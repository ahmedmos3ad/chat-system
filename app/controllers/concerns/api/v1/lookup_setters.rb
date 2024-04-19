module API::V1::LookupSetters
  extend ActiveSupport::Concern

  private

  def set_current_application
    @application = Application.find_by!(token: params[:token])
  end

  def set_current_chat_room_application
    @application = Application.find_by!(token: params[:application_token])
  end

  def set_current_chat_message_chat_room
    @chat_room = ChatRoom.find_by!(number: params[:chat_number])
  end
end