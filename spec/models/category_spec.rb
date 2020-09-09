# frozen_string_literal: true

require 'rails_helper'
# Category
RSpec.describe Category, type: :model do
  describe 'Model' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:category)).to be_valid
    end

    let(:category) { FactoryBot.build(:category) }
    describe 'ActiveModel validations' do
      it { expect(category).to validate_presence_of(:title) }
      it { expect(category).to validate_uniqueness_of(:title) }
    end

    describe 'ActiveRecord associations' do
      it { expect(category).to have_many(:parent_relations) }
      it { expect(category).to have_many(:child_relations) }
      it { expect(category).to have_many(:parents)
                                   .through(:parent_relations)
                                   .source(:child_category)
                                   .dependent(:destroy) }
      it { expect(category).to have_many(:children)
                                   .through(:child_relations)
                                   .source(:parent_category)
                                   .dependent(:destroy) }
    end
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      let(:category) { FactoryBot.create(:category) }
      it { expect(category).to respond_to(:all_children) }
      it { expect(category).to respond_to(:recursive_tree_children) }
    end

    context 'executes methods correctly' do
      context '#all_children' do
        let(:category1) { FactoryBot.create(:category) }
        let(:category2) { FactoryBot.create(:category, parents: [category1]) }
        let(:category3) { FactoryBot.create(:category, parents: [category2]) }
        it 'should level 1' do
          category2
          expect(category1.all_children.size).to eq(1)
        end
        it 'should level 2' do
          category3
          expect(category1.all_children.size).to eq(2)
        end
      end
    end
  end
end
