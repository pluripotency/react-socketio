path = require 'path'

module.exports =
  # url_root can be defined in default.coffee only.
  url_root: ''

  dist_dir: path.join(__dirname, '..', 'dist')
  gulpServerSrc: path.join(__dirname, '..', 'src/server')+'/*.js'
  server:
    port: '3000'
