#encoding: utf-8
module AnimesHelper
  def score_tag(score)
    total_stars = 10
    black_stars = score || 0
    white_stars = total_stars - black_stars
    content_tag :span, "★" * black_stars + "☆" * white_stars
  end
  
  def small_button_to(text, path, params={})
    params[:class] = "btn btn-default btn-sm" unless params[:class]
    button_to text, path, params
  end
end
