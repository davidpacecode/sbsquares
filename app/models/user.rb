class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  enum :role, { player: 0, admin: 1 }, default: :player

  validates :first_name, :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def initials
    first_name[0,1] + last_name[0,1]
  end
end
