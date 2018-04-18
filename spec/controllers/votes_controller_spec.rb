require 'rails_helper'
include SessionsHelper

RSpec.describe VotesController, type: :controller do
  let(:my_user) { User.create!(name: 'Bloccit User', email: 'user@bloccit.com', password: 'helloworld') }
  let(:other_user) { User.create!(name: RandomData.random_name, email: RandomData.random_email, password: 'helloworld', role: :member) }
  let(:my_topic) { Topic.create!(name:  RandomData.random_sentence, description: RandomData.random_paragraph) }
  let(:user_post) { my_topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: other_user) }
  let(:my_vote) { Vote.create!(value: 1) }

  # we test that unsigned-in users are redirected to the sign-in page, as they will not be allowed to vote on posts.
  context 'guest' do
    describe 'POST up_vote' do
      it 'redirects the user to the sign in view' do
        post :up_vote, params: { post_id: user_post.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  # we create a context to test signed-in users, who should be allowed to vote on posts.
  context 'signed in user' do
    before do
      create_session(my_user)
      request.env['HTTP_REFERER'] = topic_post_path(my_topic, user_post)
    end

    describe 'POST up_vote' do
      # we expect that the first time a user up votes a post, a new vote is created for the post.
      it 'the users first vote increases number of post votes by one' do
        votes = user_post.votes.count
        post :up_vote, params: { post_id: user_post.id }
        expect(user_post.votes.count).to eq(votes + 1)
      end

      # we test that a new vote is not created if the user repeatedly up votes a post.
      it 'the users second vote does not increase the number of votes' do
        post :up_vote, params: { post_id: user_post.id }
        votes = user_post.votes.count
        post :up_vote, params: { post_id: user_post.id }
        expect(user_post.votes.count).to eq(votes)
      end

      # we expect that up voting a post will increase the number of points on the post by one.
      it 'increases the sum of post votes by one' do
        points = user_post.points
        post :up_vote, params: { post_id: user_post.id }
        expect(user_post.points).to eq(points + 1)
      end

      # #22
      it ':back redirects to posts show page' do
        request.env['HTTP_REFERER'] = topic_post_path(my_topic, user_post)
        post :up_vote, params: { post_id: user_post.id }
        expect(response).to redirect_to([my_topic, user_post])
      end

      # #23
      it ':back redirects to posts topic show' do
        request.env['HTTP_REFERER'] = topic_path(my_topic)
        post :up_vote, params: { post_id: user_post.id }
        expect(response).to redirect_to(my_topic)
      end
    end
  end
end
