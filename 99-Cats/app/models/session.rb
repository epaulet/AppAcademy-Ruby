class Session < ActiveRecord::Base
  validates :session_token, :user_id, presence: true
  validates :session_token, uniqueness: true

  belongs_to(
    :user,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id
  )

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def self.create_session(user_id)
    Session.create(
      session_token: self.generate_session_token,
      user_id: user_id
      )
  end
end
