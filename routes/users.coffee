# -----------------------------------------------
#
# Router: Users API
# - Handles Users REST API
#
# -----------------------------------------------

mongoose = require 'mongoose'
express  = require 'express'
router   = express.Router()
User   = require '../models/user'

# GET /users : Return all users
# -------------------------------
router.get '/', (req, res) ->
  User.find (err, users) ->
    res.send err if err
    res.json users

# POST /users : Create a user and return it
# -------------------------------------------
router.post '/', (req, res) ->
  user = new User
    username: req.body.username
    password: req.body.password
    email: req.body.email
  user.save (err, user) ->
    res.send err if err
    res.status(201).json user


# GET /users/:user_id : Return a single user by id
# -------------------------------------------------
router.get '/:user_id', (req, res) ->
  User.findById req.params.user_id, (err, user) ->
    res.status(400).send err if err
    res.json user

# Get /users/:username : Return a single user by username
# -------------------------------------------------
router.get '/:username', (req, res) ->
  User.findOne
    username: req.params.username
  , (err, user) ->
    res.status(400).send err if err
    res.json user

# DELETE /users/:user_id : Delete a user by ID
# -----------------------------------------------
router.delete '/:user_id', (req, res) ->
  User.remove
    _id: req.params.user_id
  , (err) ->
    res.status(400).send err if err
    res.status(204).end()

# PUT /users/:user_id : Update a user by ID
# --------------------------------------------
router.put '/:user_id', (req, res) ->
  User.findById req.params.user_id, (err, user) ->
    res.status(400).send err if err
    user.password = req.body.password
    user.email = req.body.email
    user.username = req.body.username
    user.save (err, updatedUser) ->
      res.status(400).send err if err
      res.json updatedUser

module.exports = router
