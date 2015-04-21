# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  user_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  validates :user_name, uniqueness: true, presence: true

  has_many(
    :authored_polls,
    class_name: 'Poll',
    foreign_key: :author_id,
    primary_key: :id
  )

  has_many(
    :responses,
    class_name: 'Response',
    foreign_key: :user_id,
    primary_key: :id
  )

  def completed_polls
    Poll.find_by_sql([<<-SQL, id])
      SELECT
        polls.*, COUNT(DISTINCT(questions.id)) AS questions_per_poll,
          COUNT(responses.id) AS responses_per_poll
      FROM
        responses
      RIGHT OUTER JOIN
        answer_choices ON responses.answer_choice_id = answer_choices.id
      JOIN
        questions ON answer_choices.question_id = questions.id
      JOIN
        polls ON questions.poll_id = polls.id
      WHERE
        responses.user_id = ? OR responses.id IS NULL
      GROUP BY
        polls.id
      HAVING
        COUNT(DISTINCT(questions.id)) = COUNT(responses.id)
    SQL

    # Response
    #   .select("polls.*, COUNT(DISTINCT(questions.id)) AS david, COUNT(responses.id) AS edward")
    #   .joins("RIGHT OUTER JOIN answer_choices ON responses.answer_choice_id = answer_choices.id")
    #   .joins('INNER JOIN questions ON answer_choices.question_id = questions.id') #association symbols representation association name, NOT table name
    #   .joins('INNER JOIN polls ON questions.poll_id = polls.id') #association symbols representation association name, NOT table name
    #   .where("responses.user_id = ? OR responses.id IS NULL", self.id)
    #   .group("polls.id")
    #   .having("COUNT(DISTINCT(questions.id)) = COUNT(responses.id)")

  end
end
