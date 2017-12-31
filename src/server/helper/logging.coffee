date = require './date.coffee'
morgan = require('morgan')

stringify_circular = (json) ->
  cache = []
  JSON.stringify json, ((key, value) ->
    if typeof value == 'object' and value != null
      if cache.indexOf(value) != -1
        return
      cache.push value
    value
  ), 2

log = (args...)->
  messages = ''
  args.map (arg)->
    if typeof arg == 'object'
#      messages += JSON.stringify arg, null, 2
      messages += stringify_circular arg
    else if typeof arg == 'string'
      messages += arg
    else if typeof arg == 'function'
      messages += arg.toString()
#    else if arg instanceof RegExp
#      messages += arg.toString()

  now = date.toJaString(new Date());
  console.log now + ' ' + messages

session_log = (session, message, callback)->
  (err, result)->
    session_user = if session.user? then session.user.email
    session_admin= if session.admin? then session.admin
    if session_user == session_admin
      st = "admin:#{session_admin}"
    else
      st = "admin:#{session_admin} as #{session_user}"
    if err
      re = "err:#{err}"
    else
      re = 'success'
    log [
      st
      message
      re
    ].join ' '
    callback err, result

morgan.token 'r-addr', (req, res, format) ->
  req.header('x-forwarded-for') or req.ip or req._remoteAddress or req.connection and req.connection.remoteAddress or undefined
morgan.token 'date', (req, res, format) ->
  (date.toJaString new Date()).slice 2
morgan.token 'session', (req, res, format) ->
  if !req.session
    return 'no_ses'
  user = if req.session.user? then req.session.user.email else ''
  admin = if req.session.admin? then req.session.admin else false
  if admin
    if user == req.session.admin
      return "admin:#{admin}"
    else
      return "admin:#{admin} as #{user}"
  else
    return "user:#{user}"

logging_mw = ->
  s = [
    ':date'
    ':session'
    ':method'
    ':url'
    ':status'
    ':res[content-length]'
    ':r-addr'
  ].join ' '
  morgan s

module.exports =
  log: log
  logging_mw: logging_mw
  session_log: session_log
