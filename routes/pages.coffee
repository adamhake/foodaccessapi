express      = require 'express'
router       = express.Router()

# GET / : Homepage
# ------------------------------------------------------------------------------
router.get '/', (req, res) ->
  if req.user
    res.redirect '/stores'
  else
    res.redirect '/login'

# GET /about : About
# ------------------------------------------------------------------------------
router.get '/about', (req, res) ->
  res.render 'pages/about'


module.exports = router
