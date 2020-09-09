# frozen_string_literal: true

# CategoryRelation
class CategoryRelation < ApplicationRecord
  # Associations
  belongs_to :parent_category,
             class_name: 'Category',
             primary_key: 'id',
             foreign_key: 'child_id',
             optional: true
  belongs_to :child_category,
             class_name: 'Category',
             primary_key: 'id',
             foreign_key: 'parent_id',
             optional: true
end
