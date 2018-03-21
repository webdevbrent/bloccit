require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:question) { Question.create!(title: 'New Question', body: 'New Question Body', resolved: true)}
  let(:answer) { Answer.create!(body: 'New Answer', question: question) }

  describe 'attributes' do
    it 'has a body attribute' do
      expect(answer).to have_attributes(body: 'New Answer')
    end
  end
end
