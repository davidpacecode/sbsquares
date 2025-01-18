class Square < ApplicationRecord
  belongs_to :board
  belongs_to :user, optional: true
end
