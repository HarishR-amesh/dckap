# frozen_string_literal: true

require 'rails_helper'
# Category Relation
RSpec.describe CategoryRelation, type: :model do
  describe 'Model' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:category_relation)).to be_valid
    end

    let(:category_relation) { FactoryBot.build(:category_relation) }
    describe 'ActiveRecord associations' do
      it { expect(category_relation).to belong_to(:parent_category)
                                            .with_foreign_key('child_id')
                                            .with_primary_key('id')
                                            .class_name('Category')
                                            .optional(true) }
      it { expect(category_relation).to belong_to(:child_category)
                                            .with_foreign_key('parent_id')
                                            .with_primary_key('id')
                                            .class_name('Category')
                                            .optional(true) }
    end
  end
end
