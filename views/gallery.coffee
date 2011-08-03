window.getLocationHash = ->
  # show popup if #popup_for_<document.location.hash> exists in DOM
  hash = document.location.hash
  hash = hash.slice(1,hash.length)


gallery = ->
  anchors = $('.medium>a', '#gallery')
  thumbs = $('.medium>a>img', '#gallery')
  theater = Theater.initialize()
  anchors.click (evt)->
    theater.show(this)
    false # prevent default click actions
  $('#close_button').click ->
    theater.hide()

  $(window).hashchange -> theater.show()
  theater.show() if getLocationHash()


Theater =
  parent: false
  stage: false
  gallery: false
  media: false
  media_identifier: false
  controls: false
  current: false
  initialized: false
  initialize: (first) ->
    this.parent = $('#theater') unless this.parent
    this.stage = $('#stage') unless this.stage
    this.gallery = $('#gallery') unless this.gallery
    this.media_identifier = 'div[id^="medium_"]' unless this.media_identifier
    this.media = $(this.media_identifier) unless this.media
    this.controls = $('.control', this.stage) unless this.controls

    $(this.controls).click this.control
    this.initialized = true
    this

  setCurrent: (medium) ->
    if medium
      medium = $(medium).closest(this.media_identifier)  # just to be sure
    else
      #TODO: find a configurable way (this won't work without default media_identifier)
      hash = getLocationHash()
      if $('#medium_'+hash, this.gallery)
        medium = $('#medium_'+hash, this.gallery)
      else
        medium = $(this.media, this.gallery).first() unless medium

    this.current = medium
    $(this.stage).css('background-image', "url("+$('a', medium).attr('href')+")")

  show: (medium) ->
    this.initialize() unless this.initialized
    this.setCurrent(medium)
    this.parent.show()

  hide: ->
    this.parent.hide()

  control: ->
    current = Theater.current
    if $(this).hasClass('left')
      Theater.setCurrent(current.prev(this.media_identifier))
    else if $(this).hasClass('right')
      Theater.setCurrent(current.next(this.media_identifier))


$ -> gallery()

