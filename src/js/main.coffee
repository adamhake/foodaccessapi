$ = require "jquery"

require "./components/map.coffee"
require "./components/storeForm.coffee"

$(document).ready ->
  new Map()
  new StoreForm()
