class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  before_save { self.email = email.downcase if email.present? }
  before_save { self.role ||= :member }
  before_save :name_formatter

  validates :name, length: { minimum: 1, maximum: 100 }, presence: true
  validates :password, presence: true, length: { minimum: 6 }, if: 'password_digest.nil?'
  validates :password, length: { minimum: 6 }, allow_blank: true
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 254 }

  has_secure_password

  enum role: %i[member admin moderator]

  def name_formatter
    if name
      name_array = []
      name.split.each do |name_partial|
        name_array << name_partial.capitalize
      end
      self.name = name_array.join(' ')
    end
  end

  # This method takes a post object and uses where to retrieve the user's 
  # favorites with a post_id that matches post.id. If the user has favorited post 
  # it will return an array of one item. If they haven't favorited post it will return an empty array. 
  # Calling first on the array will return either the favorite or nil depending on whether they favorited the post.
  def favorite_for(post)
    favorites.where(post_id: post.id).first
  end

  def avatar_url(size)
    gravatar_id = Digest::MD5::hexdigest(self.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end

end
