mongoose       = require 'mongoose'
MapboxClient   = require 'mapbox'
client = new MapboxClient process.env.MAPBOX_TOKEN

storeSchema = mongoose.Schema
  name:
    type: String
    required: true
    unique: false
  address:
    street: String
    streetAux: String
    city: String
    state: String
    zipcode: Number
  coordinates:
    lat: Number
    lng: Number
  phone: String
  benefits:
    freshOptions: Boolean
    snap: Boolean
    wic: Boolean
  hours:
    days: String
    months: String
  myPlate:
    dairy: Boolean
    fruit: Boolean
    grain: Boolean
    protein: Boolean
    veggie: Boolean
  createdAt:
      type: Date
      default: Date.now


# Method: Geocode address
storeSchema.pre "save", (done) ->
  store = this;
  address = store.address
  addressString = "#{address.street}, #{address.city}, #{address.state} #{address.zipcode}"
  client.geocodeForward addressString, (err, res) ->
    if res and res.features
      store.coordinates.lat = res.features[0].geometry.coordinates[1]
      store.coordinates.lng = res.features[0].geometry.coordinates[0]
      done()
    else
      done()

module.exports = mongoose.model 'Store', storeSchema
