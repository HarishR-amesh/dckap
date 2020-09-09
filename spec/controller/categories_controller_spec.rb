# frozen_string_literal: true

require 'rails_helper'
# Categories Controller
RSpec.describe CategoriesController, type: :controller do
  # this lets us inspect the rendered results
  render_views

  let(:page) { Capybara::Node::Simple.new(response.body) }
  let(:category) { FactoryBot.create(:category) }

  let(:valid_attributes) do
    FactoryBot.attributes_for(:category)
  end

  let(:invalid_attributes) do
    { title: '' }
  end

  describe 'GET #index' do
    let!(:category1) { FactoryBot.create(:category) }
    before :each, action: true do
      get :index
    end
    it 'Get success response in index action', action: true do
      expect(response).to have_http_status 200
    end
    it 'Get render template in index action', action: true do
      expect(response).to render_template('index')
    end
    it 'assigns @categories', action: true do
      expect(assigns[:categories]).to eq([category1])
    end
  end

  describe 'GET #show' do
    let(:category1) { FactoryBot.create(:category) }
    let(:category2) { FactoryBot.create(:category) }
    let(:category3) { FactoryBot.create(:category, parents: [category1, category2]) }
    let(:category4) { FactoryBot.create(:category, parents: [category3]) }
    let(:category5) { FactoryBot.create(:category, parents: [category3]) }
    it 'should success response' do
      get :show, params: { id: category1.to_param }
      expect(response).to have_http_status 200
    end
    it 'should success render template' do
      get :show, params: { id: category1.to_param }
      expect(response).to render_template('show')
    end
    it 'Title & childerns label exists' do
      get :show, params: { id: category1.to_param }
      expect(page).to have_css('strong', text: 'Title')
      expect(page).to have_css('strong', text: 'Childrens:')
    end
    it 'Title & childerns value exists' do
      category3
      get :show, params: { id: category1.to_param }
      expect(page).to have_content(category1.title)
      expect(page).to have_content([category3.title])
    end
    it 'childerns value level 2 exists' do
      category3
      category4
      category5
      get :show, params: { id: category1.to_param }
      expect(page).to have_content(category1.title)
      expect(page).to have_content([category3.title, category4.title, category5.title])
    end
  end

  describe 'GET #new' do
    before do
      get :new
    end
    it 'have http success status' do
      expect(response).to have_http_status(:success)
    end
    it 'renders the new page' do
      expect(response).to render_template('categories/new')
    end
    it 'assigns @category' do
      expect(assigns[:category]).to be_a_new(Category)
    end
  end

  describe 'POST create' do
    context 'with valid params' do
      it 'creates a new category' do
        expect { post :create, params: { category: valid_attributes } }
            .to change(Category, :count).by(1)
      end
      it 'assigns a newly created category as @category ' do
        post :create, params: { category: valid_attributes }
        expect(assigns(:category)).to be_a(Category)
        expect(assigns(:category)).to be_persisted
      end
      it 'redirects to the created category index' do
        post :create, params: { category: valid_attributes }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(category_path(Category.last))
      end
      it 'should create the category' do
        post :create, params: { category: valid_attributes }
        category = Category.last

        expect(category.title).to eq(valid_attributes[:title])
      end
      it 'should set flash' do
        post :create, params: { category: valid_attributes }
        expect(flash[:notice]).to eq('Category was successfully created.')
      end
    end

    context 'with invalid params' do
      it 'invalid_attributes return http success' do
        post :create, params: { category: invalid_attributes }
        expect(response).to have_http_status(:success)
      end
      it 'assigns a newly created but unsaved category as @category ' do
        post :create, params: { category: invalid_attributes }
        expect(assigns(:category)).to be_a_new(Category)
      end
      it 'assigns error messages' do
        post :create, params: { category: invalid_attributes }

        expect(assigns[:category].errors.full_messages).to eq(["Title can't be blank"])
      end
      it 'invalid_attributes do not create a category' do
        expect do
          post :create, params: { category: invalid_attributes }
        end.not_to change(Category, :count)
      end
    end
  end

  describe 'GET #edit' do
    let(:category) { FactoryBot.create(:category)}
    let!(:category2) { FactoryBot.create(:category, parents: [category])}
    it 'success response' do
      get :edit, params: { id: category.to_param }
      expect(response).to have_http_status 200
    end
    it 'success template' do
      get :edit, params: { id: category.to_param }
      expect(response).to render_template('edit')
    end
    it 'Title & childerns value exists' do
      get :edit, params: { id: category.to_param }
      expect(page).to have_css("input[value=\"#{category.title}\"]")
    end
  end

  describe 'PUT #update' do
    context 'valid params' do
      it 'success response' do
        put :update, params: { id: category.id, category: { title: 'test'} }
        expect(response).to have_http_status 302
      end
      it 'success redirect page' do
        put :update, params: { id: category.id, category: { title: 'test'} }
        expect(response).to redirect_to(category_path(category))
      end
      it 'success flash message' do
        put :update, params: { id: category.id, category: { title: 'test'} }
        expect(flash[:notice]).to eq('Category was successfully updated.')
      end
      it 'check title' do
        put :update, params: { id: category.id, category: { title: 'test'} }
        category.reload
        expect(category.title).to eq('test')
      end
    end
    context 'invalid params' do
      it 'send invalid params response' do
        put :update, params: { id: category.id, category: { title: ''} }
        expect(response).to have_http_status 200
      end
      it 'send invalid params response' do
        put :update, params: { id: category.id, category: { title: ''} }
        expect(response).to have_http_status 200
      end
      it 'send invalid params template' do
        put :update, params: { id: category.id, category: { title: ''} }
        expect(response).to render_template('edit')
      end
      it 'send invalid params error message' do
        category.update(title: '')
        expect(category.errors.full_messages.to_sentence).to eq('Title can\'t be blank')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested select_option' do
      category
      expect {
        delete :destroy, params: { id: category.id }
      }.to change(Category, :count).by(-1)
    end

    it 'redirects to the field' do
      delete :destroy, params: { id: category.id }
      expect(response).to redirect_to(categories_path)
    end

    it 'should set flash' do
      delete :destroy, params: { id: category.id }
      expect(flash[:notice]).to eq('Category was successfully destroyed.')
    end
  end
end
