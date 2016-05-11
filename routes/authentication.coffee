# -----------------------------------------------
#
# Router: authentication
# - Handles login/logout functionality
#
# -----------------------------------------------

csrf        = require 'csurf'
express     = require 'express'
passport    = require 'passport'
router      = express.Router()
User        = require '../models/user'

csrfProtect = csrf
  cookie: true

# Add user to local variables if present
# --------------------------------------
router.use (req, res, next) ->
  res.locals.user = req.user
  next()

# GET /login : Auth form
# -------------------------------
router.get '/login', csrfProtect, (req, res) ->
  res.render "login",
    login: true
    csrfToken: req.csrfToken()
    message: req.flash('error')

# POST /login : authenticate user
# -------------------------------
router.post '/login', csrfProtect, passport.authenticate "login",
  successRedirect: "/stores"
  failureRedirect: "/login"
  failureFlash: true

# GET /logout : logout user
# -------------------------------
router.get '/logout', (req, res) ->
  req.logout()
  res.redirect '/'

module.exports = router
