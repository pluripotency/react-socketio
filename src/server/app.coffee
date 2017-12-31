express = require('express')
path = require('path')
favicon = require('serve-favicon')
bodyParser = require('body-parser')
session = require('express-session')
config = require('config')
socketio = require './socketio/index.coffee'

helper = require('./helper/index.coffee')

sessionMiddleware = session
    secret: 'reactsocketio'
    rolling: true
    resave: true
    saveUninitialized: true
    cookie: maxAge: 20 * 60 * 1000

app = express()
server = require('http').createServer(app)
socketio.init(server, sessionMiddleware)

if process.env.NODE_ENV != 'production'
  webpack = require('webpack')
  webpackConfig = require("../../webpack/dev.coffee")(env: 'dev')
  compiler = webpack(webpackConfig)

  app.use(require('webpack-dev-middleware')(compiler, {
    noInfo: true, publicPath: webpackConfig.output.publicPath
  }))
  console.log 'public path: ' + config.dist_dir
  app.use(require('webpack-hot-middleware')(compiler))

app.use favicon(path.join(config.dist_dir, 'images/favicon.png'))
app.use(express.static(config.dist_dir))
app.use helper.logging.logging_mw()
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)
app.use sessionMiddleware

app.use "#{config.url_root}/", require('./routes/index.coffee')

# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error('Not Found')
  err.status = 404
  next err
# error handlers
# development error handler
# will print stacktrace
if app.get('env') == 'development'
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.send
      message: err.message
      error: err
# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status err.status or 500
  res.send
    message: err.message
    error: {}

app.set 'port', process.env.PORT || config.server.port

server.listen app.get('port'), ()->
  console.log('Express server listening on port ' + server.address().port)
