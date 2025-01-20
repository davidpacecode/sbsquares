class AddNicknameToBoards < ActiveRecord::Migration[8.0]
  def change
    add_column :boards, :nickname, :text
  end
end
