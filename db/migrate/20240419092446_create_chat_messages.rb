class CreateChatMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :chat_messages do |t|
      t.references :chat_room, null: false, foreign_key: true, index: true
      t.integer :number, null: false
      t.text :body, null: false
      t.index %i[chat_room_id number], unique: true
      t.timestamps
    end
  end
end
