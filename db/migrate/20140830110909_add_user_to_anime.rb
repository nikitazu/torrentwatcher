class AddUserToAnime < ActiveRecord::Migration
  def change
    add_reference :animes, :user, index: true
  end
end
