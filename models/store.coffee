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
    zipcode: String
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
    doubleBucks: Boolean
  hours:
    days: String
    months: String
    hours: String
  myPlate:
    dairy: Boolean
    fruit: Boolean
    grain: Boolean
    protein: Boolean
    veggie: Boolean
  public: Boolean
  meals: String
  surveyed: Boolean
  created:
    type: Date
    default: Date.now
  updated:
    type: Date
    default: Date.now

# Secondary Indexes
storeSchema.index
  location: '2dsphere'

# categoryMap
categoryMap =
  farmers_market: "Farmer's Market"
  full_scale: "Full Scale"
  healthy_corner_store: "Healthy Corner Store"
  summer_feeding_site: "Summer Feeding Site"
  other: "Other"


# Method: Geocode address
storeSchema.pre "save", (done) ->
  store = this;
  # update updated
  store.updated = Date.now
  # Geocode Address
  address = store.address
  addressString = "#{address.street}, #{address.city}, #{address.state} #{address.zipcode}"
  client.geocodeForward addressString, (err, res) ->
    if err
      console.log err
    if res and res.features
      store.location.coordinates = res.features[0].geometry.coordinates
      done()
    else
      done()


storeSchema.statics.findByLocation = (location, bounds, cb) ->
  # Geocode location
  Store = this
  bounds = if bounds then parseInt bounds else 1600
  client.geocodeForward location, (err, res) ->
    if err
      cb err, []
    else if res and res.features[0]
      query =
        location:
          $near:
            $geometry:
              type: "Point"
              coordinates: res.features[0].geometry.coordinates
            $maxDistance: bounds
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
    "updated",
    "hours",
    "location",
    "myPlate",
    "category",
  ]

# Virtual Getters
storeSchema.virtual "humanCreated"
.get ->
  _date = new Date(this.created)
  return _date.toLocaleDateString()

storeSchema.virtual "humanUpdated"
.get ->
  _date = new Date(this.updated)
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
