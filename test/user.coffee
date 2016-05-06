chai = require "chai"
expect = chai.expect

User = require "../models/user"

describe "User creation", ->
  User = {}
  beforeEach ->
    User = new User
      username: "test"
      password: "1234567"
      email: "test@test.com"
  it "hash return a hashed password", ->
    
