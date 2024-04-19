# frozen_string_literal: true

class API::V1::MessagesController < API::V1::BaseController
  before_action :set_current_chat_message_chat_room
  before_action :set_paging_parameters, only: [:index, :search]

  def create
    logger.info("Creating chat message for chat_room:##{@chat_room.id}")
    chat_message = ChatMessageService.new(@chat_room, message_params).create_chat_message
    render_response(data: {chat_message: chat_message.as_serialized_json.slice(:number, :body)}, status: :accepted)
  end

  def index
    logger.info("Fetching chat messages for chat_room:##{@chat_room.id} with page: #{@page} and per_page: #{@per_page}")
    chat_messages = @chat_room.chat_messages
    render_response(data: {chat_messages: chat_messages.page(@page).per(@per_page).as_serialized_json, pagination_info: {total_count: chat_messages.count, page_number: @page, page_size: @per_page}}, status: :ok)
  end

  def search
    logger.info("Searching chat messages for chat_room:##{@chat_room.id}")
    @keyword = params[:keyword]
    raise AppException::BadRequest.new(message: "keyword is required", invalid_parameter: "keyword") if @keyword.blank?
    chat_messages, total_count = ChatMessage.search_by_keyword_and_chat_room_id(@keyword, @chat_room.id, page: @page, per_page: @per_page)
    render_response(data: {chat_messages: chat_messages.as_serialized_json, pagination_info: {total_count: total_count, page_number: @page, page_size: @per_page}}, status: :ok)
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end