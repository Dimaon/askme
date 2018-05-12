class CreateHashtags < ActiveRecord::Migration[5.1]
  def change
    create_table :hashtags do |t|
      t.text :tag
      t.timestamps
    end

    create_table :hashtags_questions do |t|
      t.belongs_to :question, index: true
      t.belongs_to :hashtag, index: true
    end
  end
end
