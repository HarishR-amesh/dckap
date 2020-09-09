class CreateCategoryRelations < ActiveRecord::Migration[6.0]
  def change
    create_table :category_relations do |t|
      t.integer :parent_id
      t.integer :child_id

      t.timestamps
    end

    add_index :category_relations, :parent_id
    add_index :category_relations, :child_id
    add_index :category_relations, [:parent_id, :child_id], unique: true
  end
end
