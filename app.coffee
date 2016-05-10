require('dotenv').config()
express      = require 'express'
app          = express()
bodyParser   = require 'body-parser'
cookieParser = require 'cookie-parser'
mongoose     = require 'mongoose'
morgan       = require 'morgan'
session      = require 'express-session'
passport     = require 'passport'
authHelpers = require './helpers/authenticationHelpers'

authRouter    = require './routes/authentication'
storesRouter  = require './routes/stores'
userRouter    = require './routes/users'
adminRouter   = require './routes/admin'

# Database
# --------------------------------------------------
mongoose.connect process.env.DATABASE_URL

# Authentication Init
# --------------------------------------------------
authHelpers.init()

# View Settings
# --------------------------------------------------
app.set 'views', './views'
app.set 'view engine', 'pug'

# Middleware
# --------------------------------------------------

# Static file directory
app.use express.static __dirname + "/dist"

# Request Logging
app.use morgan 'dev'

# Parse Cookies
app.use cookieParser()

# Parse urlencoded requests
app.use bodyParser.urlencoded
  extended: true
app.use bodyParser.json()

# Sessions
app.use session
  secret: "lskjawklj2@#SNAKSLG@2432!!"
  resave: true
  saveUninitialized: true

# passport
app.use passport.initialize()
app.use passport.session()

# Routes
app.use '/api/v1/stores', storesRouter

app.use '/', authRouter

app.use '/api/v1/users', userRouter

app.use '/', adminRouter

app.listen process.env.PORT, ->
  console.log "Listening on port #{process.env.PORT}"

module.exports = app
