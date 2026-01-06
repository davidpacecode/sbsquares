class ChangeUserIdNullOnSquares < ActiveRecord::Migration[8.1]
  def change
    change_column_null :squares, :user_id, true
  end
end
