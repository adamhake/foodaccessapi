mongoose       = require 'mongoose'
MapboxClient   = require 'mapbox'
client = new MapboxClient process.env.MAPBOX_TOKEN

storeSchema = mongoose.Schema
  name:
    type: String
    required: true
    unique: false
  category: String
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
  public: Boolean
  createdAt:
      type: Date
      default: Date.now

# categoryMap
categoryMap =
  farmersMarket: "Farmer's Market"
  fullScale: "Full Scale"
  healthyCornerStore: "Healthy Corner Store"
  other: "Other"


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

storeSchema.statics.publicAttributes = ->
  [
    "_id",
    "name",
    "address",
    "phone",
    "benefits",
    "createdAt",
    "hours",
    "coordinates",
    "myPlate"
  ]

# Virtual Getters
storeSchema.virtual "humanCreated"
.get ->
  _date = new Date(this.createdAt)
  return _date.toLocaleDateString()

storeSchema.virtual "humanPhone"
.get ->
  phone = this.phone
  if phone
    areaCode = phone.slice 0, 3
    firstThree = phone.slice 3, 6
    lastFour = phone.slice 6
    return "(" + areaCode + ")" + " " + firstThree + "-" + lastFour
  else
    return ""

storeSchema.virtual "humanCategory"
.get ->
  if this.category
    return categoryMap[this.category]
  else
    return ""

module.exports = mongoose.model 'Store', storeSchema
