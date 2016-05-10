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
  location:
    type:
      type: String
      default: "Point"
    coordinates: [Number]
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

# Secondary Indexes
storeSchema.index
  location: '2dsphere'

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
      store.location.coordinates = res.features[0].geometry.coordinates
      done()
    else
      done()


storeSchema.statics.findByLocation = (location, cb) ->
  # Geocode location
  Store = this
  client.geocodeForward location, (err, res) ->
    if err
      console.log "geocodeForward return err"
      cb err, []
    else if res and res.features[0]
      query =
        location:
          $near:
            $geometry:
              type: "Point"
              coordinates: res.features[0].geometry.coordinates
            $maxDistance: 1609.34 # One mile in meters
      Store.find query, (err, stores) ->
        cb err, stores
    else
      error = new Error()
      error.message = "Could not find a location from the given search"
      error.searchQuery = location
      cb error

storeSchema.statics.publicAttributes = ->
  [
    "_id",
    "name",
    "address",
    "phone",
    "benefits",
    "createdAt",
    "hours",
    "location",
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
