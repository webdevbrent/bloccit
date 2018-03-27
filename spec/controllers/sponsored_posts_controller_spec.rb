require 'rails_helper'

RSpec.describe SponsoredPostsController, type: :controller do
  let(:my_topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph) }
  let(:my_sponsored_post) { my_topic.sponsored_post.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, price: 100) }

  describe 'GET new' do
    it 'returns http success' do
      get :new, params: { topic_id: my_topic.id }
      expect(response).to have_http_status(:success)
    end

    it 'renders the #new view' do
      get :new, params: { topic_id: my_topic.id }
      expect(response).to render_template :new
    end

    it 'instantiates @post' do
      get :new, params: { topic_id: my_topic.id }
      expect(assigns(:sponsored_post)).not_to be_nil
    end
  end

  describe 'POST create' do
    it 'increases the number of Post by 1' do
      expect { post :create, params: { topic_id: my_topic.id, sponsored_post: { title: RandomData.random_sentence, body: RandomData.random_paragraph, price: 100 } } }.to change(SponsoredPost, :count).by(1)
    end

    it 'assigns the new post to @post' do
      post :create, params: { topic_id: my_topic.id, sponsored_post: { title: RandomData.random_sentence, body: RandomData.random_paragraph } }
      expect(assigns(:sponsored_post)).to eq SponsoredPost.last
    end

    it 'redirects to the new post' do
      post :create, params: { topic_id: my_topic.id, sponsored_post: { title: RandomData.random_sentence, body: RandomData.random_paragraph } }
      expect(response).to redirect_to [my_topic, SponsoredPost.last]
    end
  end
end
