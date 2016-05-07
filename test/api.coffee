chai      = require "chai"
expect    = chai.expect
supertest = require 'supertest'
app       = require '../app'
Store     = require '../models/store'

request = (url) ->
  @request = supertest app
  .get url
  .set "Content-Type", "application/json"

describe "GET /stores", ->
  it "returns Content-Type application/json", (done) ->
    @request = request "/api/v1/stores"
    @request.expect 200, done

  it "returns a key of stores with an array as its value", (done) ->
    @request = request "/api/v1/stores"
    @request.expect (res)->
      throw new Error "stores key is not set" unless res.body.stores
    .end done

  it "returns a key of status with value OK", (done) ->
    @request = request "/api/v1/stores"
    @request.expect (res)->
      throw new Error "status key is not set" unless res.body.status
      throw new Error "status key is not set to success" unless res.body.status is "success"
    .end done

describe "Store Objects", ->
  it "does not contain a public key", (done) ->
    @request = request "/api/v1/stores"
    @request.expect (res) ->
      throw new Error "public key is present" if res.body.stores[0].public
    .end done
