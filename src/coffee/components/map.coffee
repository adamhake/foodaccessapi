$ = require "jquery"

window.Map = class Map
  constructor: ->
    @initViews()

  initViews: ->
    if $("#map").length
      L.mapbox.accessToken = 'pk.eyJ1IjoiYWRhbWhha2UiLCJhIjoiY2lmZ3lrZWZoYW5lbXN5bHgzMWNmcG94diJ9.4Cbq9ye_ouTeIWvgqZj70g'
      map = L.mapbox.map 'map', 'mapbox.streets'
      lat = $('#map').attr 'data-lat'
      lng = $('#map').attr 'data-lng'
      L.marker([lat, lng]).addTo map
      map.setView [lat, lng], 16
