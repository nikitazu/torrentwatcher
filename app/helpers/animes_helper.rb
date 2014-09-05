#encoding: utf-8
module AnimesHelper
  def small_button_to(text, path, params={})
    params[:class] = "btn btn-default btn-sm" unless params[:class]
    button_to text, path, params
  end
  
  def star_tag(form)
    form.number_field :score,
      'class' => 'rating js-animes-rating',
      'min' => 0,
      'max' => 10,
      'step' => 1,
      'data-stars' => 10,
      'data-size' => 'xxs',
      'data-show-clear' => false,
      'data-show-caption' => false
  end
end
