var app       = require('../app')
var chai      = require("chai")
var expect    = chai.expect
var Store     = require('../models/store')
var supertest = require('supertest')

describe("GET /stores", function(){

  var request;

  beforeEach(function(){
    request = supertest(app)
    .get('/api/v1/stores')
    .set("Content-Type", "application/json");
  });

  it("returns Content-Type application/json", function(done){
    request.expect(200, done);
  });

  it("returns a key of stores with an array as its value", function(done){
    request.expect(function(res){
      if (!res.body.stores){
        throw new Error("stores key is not set")
      }
    }).end(done);
  });

  it("returns a key of status with value OK", function(done){
    request.expect(function(res){
      if(!res.body.status){
        throw new Error("status key is not set")
      }
      if(res.body.status != "success"){
        throw new Error("status key is not set to success")
      }
    }).end(done);
  });

});
