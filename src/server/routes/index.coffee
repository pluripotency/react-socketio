express = require('express')
router = express.Router()

helper = require '../helper/index.coffee'
log = helper.log
config = require 'config'

index_cache = ''
helper.file_ops.readAsUtf8 helper.file_ops.path.join(__dirname, 'index.html'), (err, index_html)->
  if err then log "err in reading index.html: #{err}"
  index_cache = index_html.replace(/<script>/, "<script src='/static#{config.url_root}/main.js'>")

router.route '*'
.get (req, res, next)=>
  res.send index_cache

module.exports = router