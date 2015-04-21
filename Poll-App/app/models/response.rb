# == Schema Information
#
# Table name: responses
#
#  id               :integer          not null, primary key
#  answer_choice_id :integer
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Response < ActiveRecord::Base
  validates :user_id, :answer_choice_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :respondent_is_not_author_of_poll

  belongs_to(
    :respondent,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id
  )

  belongs_to(
    :answer_choice,
    class_name: 'AnswerChoice',
    foreign_key: :answer_choice_id,
    primary_key: :id
  )

  has_one :question, through: :answer_choice, source: :question


  def sibling_responses #responses belonging to same Question
    # find all sibling responses even if id is NULL
    question.responses.where('? IS NULL OR responses.id != ?',
       self.id, self.id)
  end

  def respondent_has_not_already_answered_question
    # sibling_responses.each do |response|
    #   return false if response.user_id != self.user_id
    # end

    !sibling_responses.includes(:respondent).where(user_id: self.user_id).exists?
  end

  def respondent_is_not_author_of_poll
    question.poll.author_id != self.user_id
  end
end
