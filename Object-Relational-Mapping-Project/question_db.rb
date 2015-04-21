require 'singleton'
require 'sqlite3'
require 'active_support/core_ext/string'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end
end

class Table
  def save

    if id.nil?
      ivars = []

      self.instance_variables.map do |var|
        next if self.send(var[1..-1].to_sym).nil?
        ivars << var[1..-1] if var != :@id
      end

      values = []

      ivars.each do |ivar|
        values << self.send(ivar.to_sym)
      end

      question_marks = Array.new(ivars.length, '?')

      QuestionsDatabase.instance.execute(<<-SQL, *values)
        INSERT INTO
          #{self.class.to_s.downcase.pluralize}(#{ivars.join(", ")})
        VALUES
          (#{question_marks.join(", ")})
      SQL

      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      ivars = []

      self.instance_variables.map do |var|
        next if self.send(var[1..-1].to_sym).nil?
        ivars << var[1..-1] if var != :@id
      end

      values = []

      ivars.each do |ivar|
        values << self.send(ivar.to_sym)
      end

      set_array = []

      ivars.each do |ivar|
        unless self.send(ivar.to_sym).nil?
          set_array << "#{ivar} = ?"
        end
      end

      question_marks = Array.new(ivars.length, '?')

      QuestionsDatabase.instance.execute(<<-SQL, *values)
        UPDATE
          #{self.class.to_s.downcase.pluralize}
        SET
          #{set_array.join(", ")}
        WHERE
          id = #{id}
      SQL
    end
  end
end

class Question < Table
  attr_accessor :id, :title, :body, :user_id

  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL

    results.map { |result| Question.new(result) }[0]
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def find_by_author_id(author_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL

    results.map { |result| Question.new(result) }
  end

  def initialize(options = {})
    @id, @title, @body, @user_id =
      options.values_at('id', 'title', 'body', 'user_id')
  end

  def author
    User.find_by_id(user_id)
  end

  def replies
    Reply.find_by_question_id(id)
  end

  def followers
    QuestionFollow.followers_for_question_id(id)
  end

  def likers
    QuestionLike.likers_for_question_id(id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(id)
  end
end

class User < Table
  attr_accessor :id, :fname, :lname

  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL

    results.map { |result| User.new(result) }
  end

  def self.find_by_name(fname, lname)
    results = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL

    results.map { |result| User.new(result) }
  end

  def initialize(options = {})
    @id, @fname, @lname =
      options.values_at('id', 'fname', 'lname')
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    Reply.find_by_user_id(id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(id)
  end

  def average_karma
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        CAST(COUNT(question_likes.user_id) AS FLOAT)
          /COUNT(DISTINCT(questions.id)) AS av_karma
      FROM
        questions
      LEFT OUTER JOIN
        question_likes ON questions.id = question_likes.question_id
      WHERE
        questions.user_id = ?
      GROUP BY
        questions.user_id
    SQL

    result.first['av_karma']
  end
end

class Reply < Table
  attr_accessor :id, :body, :user_id, :question_id, :parent_id

  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL

    results.map { |result| Reply.new(result) }
  end

  def self.find_by_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL

    results.map { |result| Reply.new(result) }
  end

  def self.find_by_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL

    results.map { |result| Reply.new(result) }
  end

  def initialize(options = {})
    @id, @question_id, @parent_id, @user_id, @body =
      options.values_at('id', 'question_id', 'parent_id', 'user_id', 'body')
  end

  def author
    User.find_by_id(user_id)
  end

  def question
    Question.find_by_id(question_id)
  end

  def parent_reply
    Reply.find_by_id(parent_id)
  end

  def child_replies
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?
    SQL

    results.map { |result| Reply.new(result) }
  end
end

class QuestionLike
  attr_accessor :user_id, :question_id

  def self.likers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, fname, lname
      FROM
        users
      JOIN
        question_likes ON question_likes.user_id = users.id
      WHERE
        question_likes.question_id = ?
    SQL

    results.map { |result| User.new(result) }
  end

  def self.num_likes_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(user_id)
      FROM
        question_likes
      WHERE
        question_id = ?
      GROUP BY
        question_id
    SQL
    return 0 if results.empty?
    results[0]["COUNT(user_id)"]
  end

  def self.liked_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        id, title, body, questions.user_id
      FROM
        questions
      JOIN
        question_likes ON questions.id = question_likes.question_id
      WHERE
        question_likes.user_id = ?
    SQL

    results.map { |result| Question.new(result) }
  end

  def self.most_liked_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        id, title, body, questions.user_id
      FROM
        questions
      JOIN
        question_likes on questions.id = question_likes.question_id
      GROUP BY
        id
      ORDER BY
        COUNT(*) DESC
      LIMIT ?
    SQL

    results.map { |result| Question.new(result) }
  end

  def initialize(options = {})
    @user_id, @question_id =
      options.values_at('user_id', 'question_id')
  end
end

class QuestionFollow
  attr_accessor :user_id, :question_id

  def self.followers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        id, fname, lname
      FROM
        users
      INNER JOIN
        question_follows ON question_follows.user_id = users.id
      WHERE
        question_follows.question_id = ?
    SQL

    results.map { |result| User.new(result) }
  end

  def self.followed_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        id, title, body, questions.user_id
      FROM
        questions
      INNER JOIN
        question_follows ON question_follows.question_id = questions.id
      WHERE
        question_follows.user_id = ?
    SQL

    results.map { |result| Question.new(result) }
  end

  def self.most_followed_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
          id, title, body, user_id
      FROM
        questions
      WHERE
        id in (
        SELECT
          question_id
        FROM
          question_follows
        GROUP BY
          question_id
        ORDER BY
          COUNT(user_id) DESC
        LIMIT ?
      )
    SQL

    results.map { |result| Question.new(result) }
  end


  def initialize(options = {})
    @user_id, @question_id =
      options.values_at('user_id', 'question_id')
  end
end
