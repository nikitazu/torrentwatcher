class AddTagsToAnimes < ActiveRecord::Migration
  def change
    create_table :tags_animes, :id => false do |t|
        t.references :anime
        t.references :tag
    end
    add_index :tags_animes, [:anime_id, :tag_id]
  end
end
