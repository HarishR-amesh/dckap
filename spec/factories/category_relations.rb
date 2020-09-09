# frozen_string_literal: true

# Category Relation
FactoryBot.define do
  factory :category_relation do
    parent_id { create(:category).id }
    child_id { create(:category).id }
  end
end
