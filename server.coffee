####################
# This just simulates the github-pages
# server for local testing 
####################

express = require('express')
app = express()

app.use(express.static('./'))

server = app.listen 3000, () ->
  host = server.address().address
  port = server.address().port

  console.log('Static server listening at http://%s:%s', "localhost", port)
