class AddNicknameToSquares < ActiveRecord::Migration[8.0]
  def change
    add_column :squares, :nickname, :text
  end
end
