# ------------------------------------------------------------------------------
#
# Router: authentication
# - Handles login/logout functionality
#
# ------------------------------------------------------------------------------

csrf          = require 'csurf'
express       = require 'express'
passport      = require 'passport'
router        = express.Router()
User          = require '../models/user'
emails        = require '../helpers/emails'
PasswordToken = require '../models/passwordToken'
csrfProtect   = csrf
  cookie: true

# Add user to local variables if present
# ------------------------------------------------------------------------------
router.use (req, res, next) ->
  res.locals.user = req.user
  next()


# GET /login : Auth form
# ------------------------------------------------------------------------------
router.get '/login', csrfProtect, (req, res) ->
  res.render "login",
    login: true
    csrfToken: req.csrfToken()
    messages:
      info: req.flash "info"
      error: req.flash "error"


# POST /login : authenticate user
# ------------------------------------------------------------------------------
router.post '/login', csrfProtect, passport.authenticate "login",
  successRedirect: "/stores"
  failureRedirect: "/login"
  failureFlash: true


# GET /logout : logout user
# ------------------------------------------------------------------------------
router.get '/logout', (req, res) ->
  req.logout()
  res.redirect '/'


# GET /login/recover : Lost password form
# ------------------------------------------------------------------------------
router.get "/login/recover", csrfProtect, (req, res) ->
  res.render 'passwordRecover',
    login: true
    csrfToken: req.csrfToken()
    messages:
      error: req.flash 'error'
      info: req.flash 'info'


# POST /login/recover : Process lost password form
# ------------------------------------------------------------------------------
router.post "/login/recover", csrfProtect, (req, res) ->
  User.findOne
    email: req.body.email
  , (err, user) ->
    if !user
      req.flash 'error', 'No user found with that email address'
      res.redirect "/login/recover"
    else
      token = new PasswordToken
        user: user._id
      token.save (err) ->
        emails.recovery user, token, (err, response) ->
          if err
            req.flash 'error', 'A system error occurs sending an email. Please try again.'
          else
            req.flash 'info', 'A password recovery email containing next steps has been sent.'
          res.redirect "/login/recover"


# GET /login/reset :  Password reset form
# ------------------------------------------------------------------------------
router.get "/login/reset", csrfProtect, (req, res) ->
  if req.query.t
    PasswordToken.findOne
      token: req.query.t
    , (err, passwordTokenObj) ->
      if passwordTokenObj
        req.flash "info", "Please reset your password below"
      else
        req.flash "error", "Token doesn't match"
      res.render 'passwordReset',
        csrfToken: req.csrfToken()
        email: req.query.e
        messages:
          error: req.flash "error"
          info: req.flash "info"


# POST /login/reset :  Process password reset form
# ------------------------------------------------------------------------------
router.post "/login/reset", csrfProtect, (req, res) ->
  User.findOne
    email: req.body.email
  , (err, user) ->
    user.password = req.body.password
    user.save (err) ->
      unless err
        req.flash 'info', "Your password has been successfully reset!"
        res.redirect "/login"


# GET /tokens :  JSON endpoint for password Tokens
# ------------------------------------------------------------------------------
router.get "/tokens", (req, res) ->
  PasswordToken.find {}, (err, tokens) ->
    res.json tokens


module.exports = router
