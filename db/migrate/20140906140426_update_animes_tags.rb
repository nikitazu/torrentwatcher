class UpdateAnimesTags < ActiveRecord::Migration
  def change
    Anime.connection.execute("INSERT INTO tags_animes (anime_id, tag_id) SELECT id, 1 FROM animes WHERE status = 'watching'")
    Anime.connection.execute("INSERT INTO tags_animes (anime_id, tag_id) SELECT id, 2 FROM animes WHERE status = 'plan'")
  end
end
