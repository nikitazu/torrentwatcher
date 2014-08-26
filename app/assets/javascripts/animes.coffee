# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class window.AnimesModule
  constructor: ->
    console.log "foo"
  
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
    $torrents.append $("
    <div class='progress'>
      <div class='progress-bar progress-bar-striped active'
           role='progressbar'
           aria-valuenow='1'
           aria-valuemin='0'
           aria-valuemax='1'
           style='width:100%'>
        Loading...
      </div>
    </div>")
