# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(user_name: 'epaulet')
User.create!(user_name: 'ychen')
User.create!(user_name: 'CJ')
User.create!(user_name: 'David')

Poll.create!(author_id: 1, title: 'Favorite pizza topping')
Poll.create!(author_id: 3, title: 'Frozen questions')

#poll: favorite pizza toppings, poll id = 1
Question.create!(poll_id: 1, text: 'Do you like pepperoni?')
Question.create!(poll_id: 1, text: 'Do you like anchovies?')

#poll: frozen questions, poll id = 2
Question.create!(poll_id: 2, text: 'Do you want to build a snowman?')
Question.create!(poll_id: 2, text: 'Do you like Olaf?')

# question: do you like pepperoni
AnswerChoice.create!(question_id: 1, text: 'Yes') # answer_choice_id: 1
AnswerChoice.create!(question_id: 1, text: 'No') # answer_choice_id: 2

# do you like anchovies
AnswerChoice.create!(question_id: 2, text: 'Yes') # answer_choice_id: 3
AnswerChoice.create!(question_id: 2, text: 'No') # answer_choice_id: 4

# do you want to build a snowman?
AnswerChoice.create!(question_id: 3, text: 'Yes!')
AnswerChoice.create!(question_id: 3, text: 'No...')
AnswerChoice.create!(question_id: 3, text: 'Okay, bye')

# do you like olaf?
AnswerChoice.create!(question_id: 4, text: 'yes')
AnswerChoice.create!(question_id: 4, text: 'no')

Response.create!(user_id: 2, answer_choice_id: 1)
Response.create!(user_id: 2, answer_choice_id: 3)
Response.create!(user_id: 3, answer_choice_id: 2)
Response.create!(user_id: 2, answer_choice_id: 6)
