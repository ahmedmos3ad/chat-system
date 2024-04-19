class CreateChatRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :chat_rooms do |t|
      t.references :application, null: false, foreign_key: true, index: true
      t.integer :number, null: false
      t.integer :messages_count, default: 0, null: false
      t.index %i[application_id number], unique: true
      t.timestamps
    end
  end
end
