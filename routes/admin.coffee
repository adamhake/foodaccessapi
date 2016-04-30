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

# GET /stores/new : New store form
# --------------------------------
router.get '/stores/new', (req, res) ->
  res.render 'admin/new'

# POST /stores/new : Create new store
# -----------------------------------
router.post '/stores/new', (req, res) ->
  store = new Store storeHelpers.requestToObject req
  store.save (err, store) ->
    res.redirect '/stores'

# GET /stores/:store_id : Show store detail
# -----------------------------------------
router.get '/stores/:store_id', (req, res) ->
  Store.findByID req.params.store_id, (err, store) ->
    res.status(500).send err if err
    res.render 'admin/show',
      store: store

# GET /stores/:store_id/edit : Store edit form
# --------------------------------------------
router.get '/stores/:store_id/edit', (req, res) ->
  Store.findById req.params.store_id, (err, store) ->
    res.status(500).send err if err
    res.render 'admin/edit',
      store: store
      referrer: req.get "Referrer"

# GET /stores/:store_id/delte : Delete store
# ------------------------------------------
router.get '/stores/:store_id/delete', (req, res) ->
  Store.remove
    _id: req.params.store_id
  , (err) ->
    res.status(500).send err if err
    res.redirect "/stores"

module.exports = router
