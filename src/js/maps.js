import $ from "jquery"

class Map {
  constructor(){
    $(document).ready(() => {
      this.staticMap();
    });
  }

  staticMap() {
    if ($("#map").length){
      // Provide your access token
      L.mapbox.accessToken = 'pk.eyJ1IjoiYWRhbWhha2UiLCJhIjoiY2lmZ3lrZWZoYW5lbXN5bHgzMWNmcG94diJ9.4Cbq9ye_ouTeIWvgqZj70g';
      // Create a map in the div #map
      let map = L.mapbox.map('map', 'mapbox.streets');
      var lat = $('#map').attr('data-lat');
      var lng = $('#map').attr('data-lng');
      L.marker([lat, lng]).addTo(map);
      map.setView([lat, lng], 16);
    }
  }
}

export default Map
