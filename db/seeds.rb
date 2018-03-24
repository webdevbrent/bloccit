require 'random_data'

# Create unique Post
Post.find_or_create_by(title: 'Unique Post Title', body: 'Unique Post Body')

# Create Posts
50.times do
  Post.create!(
    title: RandomData.random_sentence,
    body: RandomData.random_paragraph
  )
end
posts = Post.all

# Create unique comment
Comment.find_or_create_by(post: posts.sample, body: 'Unique Comment Body')

# Create Comments
100.times do
  Comment.create!(
    post: posts.sample,
    body: RandomData.random_paragraph
  )
end

# Create Advertisements
10.times do
  Advertisement.create!(
    title: RandomData.random_sentence,
    copy: RandomData.random_paragraph,
    price: 100
  )
end

puts 'Seed finished'
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
puts "#{Advertisement.count} advertisements created"
