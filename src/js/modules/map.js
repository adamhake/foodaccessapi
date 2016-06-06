import $ from 'jquery';

class Map {
  constructor() {
    this.initMap()
  }
  initMap() {
    if ($("#map").length){
      L.mapbox.accessToken = 'pk.eyJ1IjoiYWRhbWhha2UiLCJhIjoiY2lmZ3lrZWZoYW5lbXN5bHgzMWNmcG94diJ9.4Cbq9ye_ouTeIWvgqZj70g';
      let map = L.mapbox.map('map', 'mapbox.streets', {
        scrollWheelZoom: false
      });
      let lat = $('#map').attr('data-lat');
      let lng = $('#map').attr('data-lng');
      L.marker([lat, lng]).addTo(map);
      map.setView([lat, lng], 16);
    }
  }
}

export default Map;
