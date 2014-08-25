class AddIsDeletedToAnimes < ActiveRecord::Migration
  def change
    add_column :animes, :is_deleted, :boolean
    execute "update animes set is_deleted = 'f'"
  end
end
