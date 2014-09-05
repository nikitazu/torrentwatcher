class window.AnimesModule
  constructor: ->
    @$alerts = $("#alerts_container")
    $ratings = $(".js-animes-rating")
    $ratings.rating()
    $ratings.on "rating.change", (event, value) =>
      $form = $(event.target).closest("form")
      $.ajax
        url: $form.attr("action")
        method: "POST"
        data: $form.serialize()
        dataType: "JSON"
        success: (json) => @putNotice "Anime [#{json.title}] was rated with #{value} star(s) successfully."
        error: (json) => @putError json
    
  expand: (animeLink) ->
    $torrents = $(animeLink).parent().parent().next()
    $torrents.empty()
    $torrents.toggle()
    return unless $torrents.is ":visible"
    @putProgressBarIn $torrents
    url = $torrents.data "url"
    $.get url, (data) -> 
      $torrents.empty()
      $torrents.append data
    false
  
  putProgressBarIn: ($torrents) ->
    $torrents.append $ "
    <div class='progress'>
      <div class='progress-bar progress-bar-striped active'
           role='progressbar'
           aria-valuenow='1'
           aria-valuemin='0'
           aria-valuemax='1'
           style='width:100%'>
        Loading...
      </div>
    </div>"

  putNotice: (message) ->
    @putMessage message, "notice alert"
  
  putError: (json) ->
    errorMessage = ""
    for name,text of $.parseJSON(json.responseText)
      errorMessage += "<strong>#{name}:</strong> #{text}.<br/>"
    @putMessage errorMessage, "alert alert-danger"

  putMessage: (message, classes) ->
    @$alerts.empty().append $ "
    <p class='#{classes} alert-info alert-dismissible' role='alert'>
     <button type='button' class='close' data-dismiss='alert'>
       <span aria-hidden='true'>&times;</span>
       <span class='sr-only'><%= t 'actions.dismiss' %></span>
     </button>
     #{message}
    </p>"
