class AddHeaderColorToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :header_color, :string, default: '#005a55'
  end
end
