# frozen_string_literal: true

class API::V1::ChatsController < API::V1::BaseController
  before_action :set_current_chat_room_application

  def create
    logger.info("Creating chat room for application:##{@application.id}")
    chat_room = ChatRoomService.new(@application).create_chat_room
    render_response(data: {chat_room: chat_room.as_serialized_json.slice(:number)}, status: :accepted)
  end

  def index
    logger.info("Fetching chat rooms for application:##{@application.id} with page: #{@page} and per_page: #{@per_page}")
    chat_rooms = @application.chat_rooms.page(@page).per(@per_page)
    render_response(data: {chat_rooms: chat_rooms.as_serialized_json, pagination_info: {total_count: chat_rooms.count, page_number: @page, page_size: @per_page}}, status: :ok)
  end

  def show
    logger.info("Fetching chat room for application:##{@application.id}")
    chat_room = @application.chat_rooms.find_by!(number: params[:number])
    render_response(data: {chat_room: chat_room.as_serialized_json}, status: :ok)
  end

  private

  def set_application
    @application = Application.find_by(token: params[:application_token])
  end
end