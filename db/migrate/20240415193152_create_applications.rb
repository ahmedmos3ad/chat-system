class CreateApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t|
      t.string :token, null: false
      t.string :name, null: false
      t.integer :chats_count, default: 0, null: false
      t.index :token, unique: true
      t.timestamps
    end
  end
end
