config = require './config.coffee'
url_root = config.url_root
request = require 'superagent'

date = require '../server/helper/date.coffee'
_ = require 'lodash'
log = require('../server/helper/logging.coffee').log

io = require('socket.io-client')
socket = io location.host, {path: "#{url_root}/io/socket.io"}
socket.on 'connect', ()-> console.log "connected: #{socket.id}"

socket.on 'data', (data)=> console.log data

vm =
  nav_items: [
    url: url_root
    name: 'Home'
    id: 'home'
  ]
  init: ()->

module.exports = vm


