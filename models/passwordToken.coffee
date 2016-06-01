mongoose = require 'mongoose'
token    = require 'node-uuid'

createToken = ->
    return token.v4()

passwordTokenSchema = mongoose.Schema
  token:
    type: String
    default: createToken()
  user:
    type : mongoose.Schema.ObjectId
    ref : 'User'
  created:
    type: Date
    default: Date.now()
    expires: "24h"

module.exports = mongoose.model 'PasswordToken', passwordTokenSchema
