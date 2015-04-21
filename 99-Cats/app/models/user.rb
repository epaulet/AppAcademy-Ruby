class User < ActiveRecord::Base
  validates :user_name, :password_digest, presence: true

  has_many(
    :cats,
    class_name: 'Cat',
    foreign_key: :user_id,
    primary_key: :id
  )

  has_many(
    :cat_requests,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id
  )

  has_many(
    :sessions,
    class_name: 'Session',
    foreign_key: :user_id,
    primary_key: :id
  )

  def self.find_by_session_token(session_token)
    session = Session.find_by_session_token(session_token)
    return nil if session.nil?
    User.find(session.user_id)
  end

  def self.find_by_credentials(user_name, password)
    user = self.find_by_user_name(user_name)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
end
