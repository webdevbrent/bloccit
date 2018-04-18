require 'random_data'

# Create Users
5.times do
  User.create!(
    name:     RandomData.random_name,
    email:    RandomData.random_email,
    password: RandomData.random_sentence
  )
end
users = User.all

# Create unique Post
post = Post.find_or_create_by(title: 'Unique Post Title', body: 'Unique Post Body')

# Create Topics
15.times do
  Topic.create!(
    name:         RandomData.random_sentence,
    description:  RandomData.random_paragraph
  )
end
topics = Topic.all

# Create Posts
50.times do
  post = Post.create!(
    user:   users.sample,
    topic:  topics.sample,
    title:  RandomData.random_sentence,
    body:   RandomData.random_paragraph
  )

# we update the time a post was created. 
# This makes our seeded data more realistic and will allow us to see our ranking algorithm in action 
  post.update_attribute(:created_at, rand(10.minutes .. 1.year).ago)

# we create between one and five votes for each post. [-1, 1].sample randomly 
# creates either an up vote or a down vote.
  rand(1..5).times { post.votes.create!(value: [-1, 1].sample, user: users.sample) }
end
posts = Post.all

# Create unique comments
Comment.find_or_create_by(body: 'Unique Comment Body', post: post)

# Create Comments
100.times do
  Comment.create!(
    user: users.sample,
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

# Create Questions
10.times do
  Question.create!(
    title: RandomData.random_sentence,
    body: RandomData.random_paragraph,
    resolved: false
  )
end

# Create and admin user
admin = User.create!(
  name: 'Brent Phillips',
  email: 'poposhub@gmail.com',
  password: '123456',
  role: 'admin'
)

# Create a member
member = User.create!(
  name: 'Member User',
  email: 'member@example.com',
  password: 'helloworld'
)

# Create a moderator
moderator = User.create!(
  name: 'Moderator User',
  email: 'mod@example.com',
  password: '123456',
  role: 'moderator'
)

puts 'Seed finished'
puts "#{User.count} users created"
puts "#{Topic.count} topics created"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
puts "#{Advertisement.count} advertisements created"
puts "#{Question.count} questions created"
puts "#{Vote.count} votes created"

