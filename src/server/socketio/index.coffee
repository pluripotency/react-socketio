config = require 'config'
url_root = config.url_root
helper = require '../helper/index.coffee'

# nginx must have
# https://www.nginx.com/blog/nginx-nodejs-websockets-socketio/
# upstream socket_nodes {
#     ip_hash;
#     server srv1.app.com:5000 weight=5;
#     server srv2.app.com:5000;
#     server srv3.app.com:5000;
#     server srv4.app.com:5000;
# }
# server {
#     server_name app.domain.com;
#     location / {
#         proxy_set_header Upgrade $http_upgrade;
#         proxy_set_header Connection "upgrade";
#         proxy_http_version 1.1;
#         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#         proxy_set_header Host $host;
#         proxy_pass http://socket_nodes;
#     }
# }

module.exports =
  init: (server, sessionMiddleware)->
    io = require('socket.io')(server,
      path: "#{url_root}/io"
      serveClient: false
      wsEngine: 'ws'
    )
    io.use (socket, next)-> sessionMiddleware socket.request, socket.request.res, next

    # require('./template_admin_session.coffee').init io

    io.on 'connect', (socket)->
      console.log "connect socket.io: #{socket.id}"
#      helper.logging.log socket.request.session
      socket.on 'disconnect', ()-> console.log "disconnect socket.io: #{socket.id}"
