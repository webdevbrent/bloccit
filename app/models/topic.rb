class Topic < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :sponsoredposts
end
