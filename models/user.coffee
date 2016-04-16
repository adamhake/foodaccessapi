mongoose = require 'mongoose'
bcrypt = require "bcrypt-nodejs"
SALT_FACTOR = 10

userSchema = mongoose.Schema
  username:
    type: String
    unique: true
    required: true
  email:
    type: String
    unique: true
    required: true
  password:
    type: String
    required: true
  createdAt:
    type: Date
    default: Date.now

noop = () ->

userSchema.pre "save", (done) ->
  user = this
  return done() if !user.isModified "password"
  bcrypt.genSalt SALT_FACTOR, (err, salt) ->
    return done err if err
    bcrypt.hash user.password, salt, noop, (err, hashedPassword) ->
      return done err if err
      user.password = hashedPassword
      done()

userSchema.methods.checkPassword = (guess, done) ->
  bcrypt.compare guess, this.password, (err, isMatch) ->
    done err, isMatch

module.exports = mongoose.model 'User', userSchema
