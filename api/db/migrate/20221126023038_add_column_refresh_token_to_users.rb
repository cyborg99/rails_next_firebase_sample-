class AddColumnRefreshTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :refresh_token, :string, null: false
    add_column :users, :id_token, :string, null: false
    add_index :users, :id_token, unique: true
    add_index :users, :refresh_token, unique: true
  end
end
