class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :squares
  has_many :games, through: :squares

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  after_initialize :set_nickname, if: :new_record?

  def set_nickname
    self.nickname ||= "Stranger"
  end

  enum :role, {
    member: 0,
    admin: 1,
    root: 2
  }
end
