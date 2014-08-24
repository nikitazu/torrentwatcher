class CreateAnimes < ActiveRecord::Migration
  def change
    create_table :animes do |t|
      t.string :title
      t.string :status
      t.integer :score
      t.integer :episodes
      t.integer :progress

      t.timestamps
    end
  end
end
