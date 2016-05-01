# -----------------------------------------------
#
# Router: Admin
# - Handles admin interface
#
# -----------------------------------------------

mongoose     = require 'mongoose'
express      = require 'express'
router       = express.Router()
Store        = require '../models/store'
storeHelpers = require '../helpers/storeHelpers'
authHelpers  = require '../helpers/authenticationHelpers'
User         = require '../models/user'

# -----------------------------------------------
# Store Routes
# -----------------------------------------------

# GET /stores : Return all stores
# -------------------------------
router.get '/stores', (req, res) ->
  Store.find {}
  .sort
    name: 1
  .exec (err, stores) ->
    res.send err if err
    res.render "admin/index",
      stores: stores
      user: req.user
      menu: "stores"

# GET /stores/new : New store form
# --------------------------------
router.get '/stores/new', (req, res) ->
  res.render 'admin/new',
    user: req.user
    menu: "new"

# POST /stores/new : Create new store
# -----------------------------------
router.post '/stores/new', (req, res) ->
  console.log req.body
  store = new Store storeHelpers.requestToObject req
  store.save (err, store) ->
    res.redirect '/stores'

# GET /stores/:store_id : Show store detail
# -----------------------------------------
router.get '/stores/:store_id', (req, res) ->
  Store.findById req.params.store_id, (err, store) ->
    res.status(500).send err if err
    res.render 'admin/show',
      store: store
      user: req.user

# GET /stores/:store_id/edit : Store edit form
# --------------------------------------------
router.get '/stores/:store_id/edit', (req, res) ->
  Store.findById req.params.store_id, (err, store) ->
    res.status(500).send err if err
    res.render 'admin/edit',
      store: store
      referrer: req.get "Referrer"
      user: req.user

# POST /stores/:store_id/edit : Update Stores
# --------------------------------------------
router.post '/stores/:store_id/edit', (req, res) ->
  console.log req.body
  Store.findById req.params.store_id, (err, store) ->
    res.status(400).send err if err
    store = storeHelpers.requestToObject req, store
    store.save (err, updatedStore) ->
      res.status(400).send err if err
      res.redirect "/stores"

# GET /stores/:store_id/delte : Delete store
# ------------------------------------------
router.get '/stores/:store_id/delete', (req, res) ->
  Store.remove
    _id: req.params.store_id
  , (err) ->
    res.status(500).send err if err
    res.redirect "/stores"

# -----------------------------------------------
# User Routes
# -----------------------------------------------

# GET /users/:user_id : User settings
# ------------------------------------------
router.get "/users/:user_id", (req, res) ->
  User.findById req.params.user_id, (err, user) ->
    res.status(400).send err if err
    res.render "admin/user/show",s
      user: req.user
      referrer: req.get "Referrer"
      menu: "settings"

module.exports = router
