passport = require 'passport'
express  = require 'express'
router   = express.Router()
User     = require '../models/user'

router.use (req, res, next) ->
  res.locals.user = req.user
  next()

router.get '/login', (req, res) ->
  res.render "login"

router.post '/login', passport.authenticate "login",
  successRedirect: "/"
  failureRedirect: "/login"
  failureFlash: false

router.get '/logout', (req, res) ->
  req.logout()
  res.redirect '/'

module.exports = router
