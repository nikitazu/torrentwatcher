class Tag < ActiveRecord::Base
  has_and_belongs_to_many :animes, join_table: "tags_animes"
end
