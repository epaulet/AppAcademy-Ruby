# users
30.times do
  User.create(username: Faker::Internet.user_name, password: 123456)
end

# subs
30.times do
  Sub.create(title: Faker::Lorem.words(4, true).join(" "), description: Faker::Hacker.say_something_smart, moderator_id: rand(1..30))
end
# posts
200.times do
  Post.create(title: Faker::Hacker.noun, content: Faker::Hacker.say_something_smart, author_id: rand(1..30))
end
# post_subs
Post.all.each do |post|
  rand(1..4).times do
    PostSub.create(post_id: post.id, sub_id: rand(1..30))
  end

  rand(1..6).times do
    Comment.create(content: Faker::Hacker.say_something_smart, post_id: post.id, author_id: rand(1..30))
  end
end
