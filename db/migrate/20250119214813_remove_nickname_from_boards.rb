class RemoveNicknameFromBoards < ActiveRecord::Migration[8.0]
  def change
    remove_column :boards, :nickname, :text
  end
end
