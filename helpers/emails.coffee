SparkPost = require "sparkpost"
client    = new SparkPost process.env.SPARKPOST_TOKEN
pug       = require "pug"
fs        = require "fs"

emails =
  recovery: (user, passwordToken, cb) ->
    client.transmissions.send
      transmissionBody:
        content:
          from: "help@codeforrva.org"
          subject: "Food Access Api Password Recovery"
          html: pug.renderFile './views/emails/passwordRecovery.pug',
            user: user
            token: passwordToken
        recipients: [
          address: 'adam@codeforrva.org'
        ]
    , (err, res) ->
      cb err, res

module.exports = emails
