class Post < ApplicationRecord
  belongs_to :topic
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :favorites, dependent: :destroy

  after_create :create_vote
  after_create :create_favorite

  default_scope { order('rank DESC') }
  scope :visible_to, -> (user) { user ? all : joins(:topic).where('topics.public' => true) }
  scope :ordered_by_title, -> { order('title DESC') }
  scope :ordered_by_reverse_created_at, -> { order('created_at ASC') }

  validates :title, length: {minimum: 5}, presence: true
  validates :body, length: {minimum: 20}, presence: true
  validates :topic, presence: true
  validates :user, presence: true

  def up_votes
    # we find the up votes for a post by passing value: 1 to where.
    # This fetches a collection of votes with a value of 1.
    # We then call count on the collection to get a total of all up votes.
    votes.where(value: 1).count
  end

  def down_votes
    # we find the down votes for a post by passing value: -1 to where.
    # where(value: -1) fetches only the votes with a value of -1.
    # We then call count on the collection to get a total of all up votes.
    votes.where(value: -1).count
  end

  def points
    # we use ActiveRecord's sum method to add the value of all the given post's votes.
    # Passing :value to sum tells it what attribute to sum in the collection.
    votes.sum(:value)
  end

  def update_rank
    age_in_days = (created_at - Time.new(1970, 1, 1)) / 1.day.seconds
    new_rank = points + age_in_days
    update_attribute(:rank, new_rank)
  end

  private

  def create_vote
    user.votes.create(value: 1, post: self)
  end

  def create_favorite
    Favorite.create(post: self, user: self.user)
    FavoriteMailer.new_post(self).deliver_now
  end
end
