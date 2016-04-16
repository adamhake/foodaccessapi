mongoose = require 'mongoose'
express  = require 'express'
router   = express.Router()
Store    = require '../models/store'
authHelpers = require '../helpers/authenticationHelpers'

router.get '/', authHelpers.ensureAuthenticated, (req, res) ->
  Store.find {}
  .sort
    name: 1
  .exec (err, stores) ->
    res.send err if err
    res.render "admin/index",
      stores: stores

module.exports = router
