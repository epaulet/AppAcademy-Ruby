class User < ActiveRecord::Base
  validates_presence_of :username, :password_digest, :session_token
  validates :password, length: { minimum: 6, allow_nil: true }

  attr_reader :password

  before_validation :ensure_session_token

  has_many :goals, dependent: :destroy

  def ensure_session_token
    get_session_token unless self.session_token
  end

  def get_session_token
    self.session_token = SecureRandom::urlsafe_base64(16)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def self.find_by_credentials(username, password)
    return unless user = User.find_by_username(username)
    user if user.is_password?(password)
  end
end
