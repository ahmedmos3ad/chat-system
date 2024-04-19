class ChatMessage < ApplicationRecord
  include ChatMessage::ChatMessageHelper
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings index: { number_of_shards: 1, max_ngram_diff: 19 } do
    mappings dynamic: 'false' do
      indexes :chat_room_id, type: 'long'
      indexes :body, type: 'text', analyzer: 'ngram_analyzer', search_analyzer: 'standard'
    end
  
    settings analysis: {
      analyzer: {
        ngram_analyzer: {
          tokenizer: "ngram_tokenizer",
          filter: %w(lowercase asciifolding)
        }
      },
      tokenizer: {
        ngram_tokenizer: {
          type: "ngram",
          min_gram: 1,
          max_gram: 20,
          token_chars: ["letter", "digit"]
        }
      }
    }
  end
  
  attr_accessor :skip_number_validation

  belongs_to :chat_room

  validates :body, presence: true
  validates :number, presence: true, uniqueness: { scope: :chat_room_id }, unless: -> { skip_number_validation }

  after_create :add_chat_room_to_chat_rooms_with_new_messages_set

  def self.search_by_keyword_and_chat_room_id(keyword, chat_room_id, page: 1, per_page: 10)
    search = search(
      query: {
        bool: {
          must: [
            {
              match: {
                body: keyword
              }
            },
            {
              term: {
                chat_room_id: chat_room_id
              }
            }
          ]
        }
      }
    )
    records = search.page(page).per(per_page).records
    total_count = search.total_count
    [records, total_count]
  end
end

# == Schema Information
#
# Table name: chat_messages
#
#  id           :bigint           not null, primary key
#  body         :text(65535)      not null
#  number       :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  chat_room_id :bigint           not null
#
# Indexes
#
#  index_chat_messages_on_chat_room_id             (chat_room_id)
#  index_chat_messages_on_chat_room_id_and_number  (chat_room_id,number) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (chat_room_id => chat_rooms.id)
#
