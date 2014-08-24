json.array!(@animes) do |anime|
  json.extract! anime, :id, :title, :status, :score, :episodes, :progress
  json.url anime_url(anime, format: :json)
end
