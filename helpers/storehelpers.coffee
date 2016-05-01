module.exports.requestToObject = (req, store = false) ->
  address =
    street: req.body.streetAddress
    streetAux: req.body.streetAddressAux
    city: req.body.city
    state: req.body.state
    zipcode: parseInt(req.body.zipcode)
  if req.body.myPlate
    benefits =
      freshOptions: if req.body.benefits.indexOf("freshOptions") == -1 then false else true
      snap: if req.body.benefits.indexOf("snap") == -1 then false else true
      wic: if req.body.benefits.indexOf("wic") == -1 then false else true
  if req.body.myPlate
    myPlate =
      dairy: if req.body.myPlate.indexOf("myPlateDairy") == -1 then false else true
      fruit: if req.body.myPlate.indexOf("myPlateFruit") == -1 then false else true
      grain: if req.body.myPlate.indexOf("myPlateGrain") == -1 then false else true
      protein: if req.body.myPlate.indexOf("myPlateProtein") == -1 then false else true
      veggie: if req.body.myPlate.indexOf("myPlateVeggie") == -1 then false else true
  hours =
    days: req.body.hourDays
    months: req.body.hourMonths
  if store
    store.address = address
    store.benefits = benefits
    store.myPlate = myPlate
    store.hours = hours
    store.name = req.body.name
    store.phone = req.body.phone
    store.category = req.body.category
    store.public = if req.body.public then true else false
  else
    store =
      address: address
      benefits: benefits
      myPlate: myPlate
      hours: hours
      name: req.body.name
      phone: req.body.phone
      category: req.body.category
      public: if req.body.public then true else false
  return store
