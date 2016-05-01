# -----------------------------------------------
#
# Router: authentication
# - Handles login/logout functionality
#
# -----------------------------------------------

passport = require 'passport'
express  = require 'express'
router   = express.Router()
User     = require '../models/user'

# Add user to local variables if present
# --------------------------------------
router.use (req, res, next) ->
  res.locals.user = req.user
  next()

# GET /login : Auth form
# -------------------------------
router.get '/login', (req, res) ->
  res.render "login",
    login: true

# POST /login : authenticate user
# -------------------------------
router.post '/login', passport.authenticate "login",
  successRedirect: "/"
  failureRedirect: "/login"
  failureFlash: false

# GET /logout : logout user
# -------------------------------
router.get '/logout', (req, res) ->
  req.logout()
  res.redirect '/'

module.exports = router
