class AddIndexToHashtags < ActiveRecord::Migration[5.1]
  def change
    add_index :hashtags, :tag, unique: true
  end
end
