class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :user_name, null: true
      t.string :uid, null: false
      t.string :email, null: true

      t.timestamps
    end
    add_index :users, :user_name, unique: true
    add_index :users, :email, unique: true
    add_index :users, :uid, unique: true
  end
end
