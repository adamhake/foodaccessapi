# ------------------------------------------------------------------------------
#
# Router: Admin
# - Handles admin interface
#
# ------------------------------------------------------------------------------

mongoose     = require 'mongoose'
express      = require 'express'
router       = express.Router()
Store        = require '../models/store'
storeHelpers = require '../helpers/storeHelpers'
authHelpers  = require '../helpers/authenticationHelpers'
User         = require '../models/user'


# fs  = require 'fs'
# router.get "/import", (req, res) ->
#   fs.readFile __dirname + '/storesImport.json', (err, data) ->
#     if err then console.log err
#     if data
#       _stores = JSON.parse(data)
#       Store.collection.insert _stores, (err, stores) ->
#         if err then console.log err
#         res.redirect "/"
#
#
# router.get "/resave", (req, res) ->
#   Store.find {}
#   .exec (err, stores) ->
#     savedCount = 0
#     for store, index in stores
#       if store.location.coordinates.length == 0
#         savedCount++
#         store.save (err, store) ->
#           return true
#     console.log("Total Saved: " + savedCount)
#     res.redirect "/stores"
#
# router.get "/reset", (req, res) ->
#   Store.remove {}, ->
#     res.redirect "/stores"


# ------------------------------------------------------------------------------
# Store Routes
# ------------------------------------------------------------------------------


# GET /stores : Return all stores
# ------------------------------------------------------------------------------
router.get '/stores', authHelpers.isAuthenticated, (req, res) ->
  Store.find {}
  .sort
    name: 1
  .exec (err, stores) ->
    res.send err if err
    res.render "admin/index",
      stores: stores
      user: req.user
      menu: "stores",
      messages:
        info: req.flash "info"
        error: req.flash "error"


# GET /stores/new : New store form
# ------------------------------------------------------------------------------
router.get '/stores/new', authHelpers.isAuthenticated, (req, res) ->
  res.render 'admin/new',
    user: req.user
    menu: "new"


# POST /stores/new : Create new store
# ------------------------------------------------------------------------------
router.post '/stores/new', authHelpers.isAuthenticated, (req, res) ->
  console.log req.body
  store = new Store storeHelpers.requestToObject req
  store.save (err, store) ->
    if err
      res.status(500).send err
    else
      req.flash "info", "Store successfully created"
      res.redirect '/stores'


# GET /stores/:store_id : Show store detail
# ------------------------------------------------------------------------------
router.get '/stores/:store_id', authHelpers.isAuthenticated, (req, res) ->
  Store.findById req.params.store_id, (err, store) ->
    res.status(500).send err if err
    res.render 'admin/show',
      store: store
      user: req.user


# GET /stores/:store_id/edit : Store edit form
# ------------------------------------------------------------------------------
router.get '/stores/:store_id/edit', authHelpers.isAuthenticated, (req, res) ->
  Store.findById req.params.store_id, (err, store) ->
    if err
      res.status(500).send err
    else
      res.render 'admin/edit',
        store: store
        referrer: req.get "Referrer"
        user: req.user


# POST /stores/:store_id/edit : Update Stores
# ------------------------------------------------------------------------------
router.post '/stores/:store_id/edit', authHelpers.isAuthenticated, (req, res) ->
  Store.findById req.params.store_id, (err, store) ->
    res.status(400).send err if err
    store = storeHelpers.requestToObject req, store
    store.save (err, updatedStore) ->
      res.status(400).send err if err
      req.flash 'info', "#{updatedStore.name} sucessfully updated."
      res.redirect "/stores"


# GET /stores/:store_id/delte : Delete store
# ------------------------------------------------------------------------------
router.get '/stores/:store_id/delete', authHelpers.isAuthenticated, (req, res) ->
  Store.remove
    _id: req.params.store_id
  , (err) ->
    if err
      res.status(500).send err
    else
      res.redirect "/stores"


# ------------------------------------------------------------------------------
# User Routes
# ------------------------------------------------------------------------------

# GET /users : User List
# ------------------------------------------------------------------------------
router.get "/users/", authHelpers.isAuthenticated, (req, res) ->
  User.find {}, (err, users) ->
    if err
      res.status(500).send err
    else
      res.render "admin/user/index",
        user: req.user
        users: users
        messages:
          info: req.flash "info"
          error: req.flash "error"

# GET /users/:user_id : User settings
# ------------------------------------------------------------------------------
router.get "/users/:user_id/edit", authHelpers.isAuthenticated, (req, res) ->
  User.findById req.params.user_id, (err, user) ->
    if err
      res.status(500).send err
    else if req.user._id.equals user._id
      res.render "admin/user/edit",
        user: req.user
        referrer: req.get "Referrer"
        menu: "settings"
        messages:
          info: req.flash "info"
          error: req.flash "error"
        newUser:
          username: if req.query.username then req.query.username else ""
          email: if req.query.email then req.query.email else ""
    else
      res.status(401).send "Not Authorized"

# POST /users/:user_id : Process user settings form
# ------------------------------------------------------------------------------
router.post "/users/:user_id/edit", authHelpers.isAuthenticated, authHelpers.validateUserForm, (req, res) ->
  User.findById req.params.user_id, (err, user) ->
    res.status(500).send err if err
    user.username = req.body.username
    user.email = req.body.email
    if req.body.password
      user.password = req.body.password
    user.save (err, updatedUser) ->
      if err
        res.status(500).send err
      else
        req.flash 'info', "User settings successfully updated."
        res.redirect "/stores"

router.post "/users/new", authHelpers.isAuthenticated, authHelpers.validateUserForm, (req, res) ->
  user = new User
    username: req.body.username
    password: req.body.password
    email: req.body.email
  user.save (err, user) ->
    if err
      res.status(500).send err
    else
      req.flash "info", "New User Created"
      res.redirect '/stores'

module.exports = router
