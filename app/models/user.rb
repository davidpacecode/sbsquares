class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :squares
  has_many :games, through: :squares

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  after_initialize :set_nickname, if: :new_record?

  def set_nickname
   self.nickname ||= self.first_name
  end

  def initials
    "#{self.first_name[0]}#{self.last_name[0]}"
  end

  enum :role, {
    member: 0,
    admin: 1,
    root: 2
  }
end
