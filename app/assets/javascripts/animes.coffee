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
    url = $torrents.data "url"
    $.get url, (data) -> $torrents.append data
    false
