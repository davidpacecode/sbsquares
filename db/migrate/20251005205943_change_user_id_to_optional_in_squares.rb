class ChangeUserIdToOptionalInSquares < ActiveRecord::Migration[8.0]
  def change
    change_column_null :squares, :user_id, true
  end
end
