class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :squares
  has_many :games, through: :squares

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  enum :role, {
    member: 0,
    admin: 1,
    root: 2
  }
end
