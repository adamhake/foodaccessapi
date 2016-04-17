module.exports.requestToObject = (req, store = false) ->
  address =
    street: req.body.streetAddress
    streetAux: req.body.streetAddressAux
    city: req.body.city
    state: req.body.state
    zip: req.body.zip
  benefits =
    freshOptions: req.body.freshOptions
    snap: req.body.snap
    wic: req.body.wic
  myPlate =
    dairy: req.body.myPlateDairy
    fruit: req.body.myPlateFruit
    grain: req.body.myPlateGrain
    protein: req.body.myPlateProtein
    veggie: req.body.myPlateVeggie
  hours =
    days: req.body.hourDays
    months: req.body.hourMonths
  if store
    store.address = address
    store.benefits = benefits
    store.myPlate = myPlate
    store.hours = hours
    store.name = name
  else
    store =
      address: address
      benefits: benefits
      myPlate: myPlate
      hours: hours
      name: req.body.name
  return store
