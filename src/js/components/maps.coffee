$ = require "jquery"

$(document).ready ()->
  if $("#map").length
    # Provide your access token
    L.mapbox.accessToken = 'pk.eyJ1IjoiYWRhbWhha2UiLCJhIjoiY2lmZ3lrZWZoYW5lbXN5bHgzMWNmcG94diJ9.4Cbq9ye_ouTeIWvgqZj70g'
    # Create a map in the div #map
    map = L.mapbox.map 'map', 'mapbox.streets'
    _lat = $('#map').attr 'data-lat'
    _lng = $('#map').attr 'data-lng'
    L.marker([_lng, _lat]).addTo(map);
    map.setView [_lng, _lat], 16
