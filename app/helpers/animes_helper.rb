#encoding: utf-8
module AnimesHelper
  def score_tag(score)
    total_stars = 10
    black_stars = score
    white_stars = total_stars - black_stars
    content_tag :span, "★" * black_stars + "☆" * white_stars
  end
end
