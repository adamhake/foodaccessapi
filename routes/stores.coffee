# -----------------------------------------------
#
# Router: Store API
# - Handles REST store api
#
# -----------------------------------------------

mongoose = require 'mongoose'
express  = require 'express'
router   = express.Router()
Store    = require '../models/store'
helpers  = require '../helpers/storehelpers'

# GET /stores : Return all stores
# -------------------------------
router.get '/', (req, res) ->
  Store.find (err, stores) ->
    res.send err if err
    res.json helpers.formatResponse stores

# POST /stores : Create a Store and return it
# -------------------------------------------
router.post '/', (req, res) ->
  store = new Store storeHelpers.requestToObject req
  store.save (err, store) ->
    res.send err if err
    res.status(201).json store

# GET /stores/:store_id : Return a single store
# ---------------------------------------------
router.get '/:store_id', (req, res) ->
  Store.findById req.params.store_id, (err, store) ->
    res.status(400).send err if err
    res.json store

# DELETE /stores/:store_id : Delete a store by ID
# -----------------------------------------------
router.delete '/:store_id', (req, res) ->
  Store.remove
    _id: req.params.store_id
  , (err) ->
    res.status(400).send err if err
    res.status(204).end()

# PUT /stores/:store_id : Update a store by ID
# --------------------------------------------
router.put '/:store_id', (req, res) ->
  Store.findById req.params.store_id, (err, store) ->
    res.status(400).send err if err
    store = storeHelpers.requestToObject req, store
    store.save (err, updatedStore) ->
      res.status(400).send err if err
      res.json updatedStore

module.exports = router
