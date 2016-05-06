chai = require "chai"
expect = chai.expect

storeHelpers = require "../helpers/storeHelpers.coffee"

describe "store helpers", ->
  _id = 23529192951
  Store =
    _id: _id
  it "should return the store if passed", ->
    expect
