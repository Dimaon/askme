class AddAuthorToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :author_id, :bigint
    add_index :questions, :author_id
  end
end
