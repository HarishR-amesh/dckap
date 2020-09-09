# frozen_string_literal: true

# Category
class Category < ApplicationRecord
  # Associations
  has_many :parent_relations,
           class_name: 'CategoryRelation',
           foreign_key: 'child_id'
  has_many :child_relations,
           class_name: 'CategoryRelation',
           foreign_key: 'parent_id'
  has_many :parents,
           through: :parent_relations,
           foreign_key: 'child_id',
           primary_key: 'id',
           source: :child_category,
           dependent: :destroy
  has_many :children,
           through: :child_relations,
           foreign_key: 'parent_id',
           primary_key: 'id',
           source: :parent_category,
           dependent: :destroy
  # Instance Methods
  def all_children
    Category.find_by_sql(recursive_tree_children)
  end

  def recursive_tree_children
    columns = CategoryRelation.column_names
    columns_joined = columns.join(',')
    sql =
        <<-SQL
          WITH RECURSIVE category_tree (#{columns_joined}, level) AS (
              SELECT #{columns_joined},
                     0
              FROM category_relations
              WHERE category_relations.parent_id = #{id}
          
              UNION ALL
          
              SELECT #{columns.map { |col| 'cr.' + col }.join(',')},
                     ct.level + 1
              FROM category_relations cr, category_tree ct
              WHERE cr.parent_id = ct.child_id
          )
          SELECT category_tree.child_id,
                 categories.title,
                 category_tree.level
          FROM category_tree
          INNER JOIN categories ON categories.id = category_tree.child_id
          where level >= 0
          ORDER BY level
        SQL
    sql.chomp
  end
end
