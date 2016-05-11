passport = require 'passport'
User     = require '../models/user'
LocalStrategy = require('passport-local').Strategy

module.exports.init = () ->

  passport.serializeUser (user, done) ->
    done null, user._id

  passport.deserializeUser (id, done) ->
    User.findById id, (err, user) ->
      done err, user


  authenticate = (username, password, done) ->
    User.findOne
      username: username
    , (err, user) ->
      done err if err
      if !user then return done null, false,
        message: "No user found with that username"
      user.checkPassword password, (err, isMatch) ->
        done err if err
        if isMatch
          return done null, user
        else
          return done null, false,
            message: "Invalid Password"

  strategy = new LocalStrategy authenticate

  passport.use "login", strategy

module.exports.isAuthenticated = (req, res, next) ->
  if req.isAuthenticated()
    next()
  else
    res.redirect '/login'
