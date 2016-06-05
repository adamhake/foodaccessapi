$ = require "jquery"

require "./components/map.coffee"

require "./components/storeForm.coffee"

require "./components/dynatable.coffee"

require "./components/reactTable.coffee"

$(document).ready ->
  new Map()
  new StoreForm()
