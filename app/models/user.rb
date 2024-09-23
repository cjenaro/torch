class User < ApplicationRecord
  has_secure_password

  has_many :memberships, dependent: :destroy
  has_many :workspaces, through: :memberships
  has_many :activities, dependent: :destroy

  before_save { email.downcase! }
  before_create :create_activation_digest

  validates :name, presence: true, length: { maximum: 40 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, length: { maximum: 100 },
    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 8 }

  attr_accessor :activation_token
  attr_accessor :reset_token

  def create_reset_digest
    self.reset_token = SecureRandom.urlsafe_base64
    update_columns(reset_digest: digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  private

  def create_activation_digest
    self.activation_token = SecureRandom.urlsafe_base64
    self.activation_digest = digest(activation_token)
  end

  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
