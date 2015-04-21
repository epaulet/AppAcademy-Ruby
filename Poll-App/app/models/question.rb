# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  poll_id    :integer
#  text       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Question < ActiveRecord::Base
  validates :text, :poll_id, presence: true
  belongs_to(
    :poll,
    class_name: 'Poll',
    foreign_key: :poll_id,
    primary_key: :id
  )

  has_many(
    :answer_choices,
    class_name: 'AnswerChoice',
    foreign_key: :question_id,
    primary_key: :id
  )

  has_many :responses, through: :answer_choices, source: :responses


  def results
    # results = {}
    #
    # answer_choices.each do |answer_choice|
    #   results[answer_choice] = answer_choice.responses.length
    # end

    # answer_choices = self.answer_choices.includes(:responses)
    # results = {}
    #
    # answer_choices.each do |answer_choice|
    #   results[answer_choice] = answer_choice.responses.length
    # end

    # .select("answer_choices.*, COALESCE(COUNT(responses.id), 0) AS response_count")

    results = self
    .answer_choices
    .select("answer_choices.*, COUNT(responses.id) AS response_count")
    .joins("LEFT OUTER JOIN responses ON responses.answer_choice_id = answer_choices.id")
    .group("answer_choices.id")

    results.map do |answer_choice|
      [answer_choice.text, answer_choice.response_count]
    end
  end
end
