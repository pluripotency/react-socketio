_ = require 'lodash'
fs = require 'fs'
path = require 'path'
async = require 'async'


isFile = (path, callback)->
  fs.stat path, (err, stats)->
    if err then return callback "err in isFile: path: #{path}, err: #{err}"
    callback null, stats.isFile()

isDir = (path, callback)->
  fs.stat path, (err, stats)->
    if err then return callback "err in isDir: path: #{path}, err: #{err}"
    callback null, stats.isDirectory()

readAsUtf8 = (file_path, callback) ->
  isFile file_path, (err, is_file)->
    if err then return callback err
    if is_file
      fs.readFile file_path, 'utf8', callback
    else
      callback "not file: #{file_path}"

ensureExistDir = (dir, mask, callback) ->
  if typeof mask == 'function'
    callback = mask
    mask = 0o755
  fs.mkdir dir, mask, (err) ->
    if err
      if err.code == 'EEXIST'
        callback null
      else if err.code == 'ENOENT'
        ensureExistDir path.dirname(dir), mask, (err) ->
          if err
            return callback(err)
          # something wrong.
          ensureExistDir dir, mask, callback
      else
        # something wrong.
        callback err
    else
      callback null

prepareCleanDir = (abs_dir_path, callback) ->
  ensureExistDir abs_dir_path, (err) ->
    if err then return callback(err)
    delAllFilesInDir abs_dir_path, (err) ->
      if err then callback err
      callback()

catalogueDir = (dir, expression, callback) ->
  fs.readdir dir, (err, files) ->
    if err then return callback "err: catalogueDir: #{err}"
    filtered_files = _.reduce files, (sum, file) ->
      if file.match(expression)
        sum.push file
      sum
    , []
    callback null, filtered_files

delAllFilesInDir = (dir, callback) ->
  catalogueDir dir, /.+/, (err, file_list) ->
    if err then return callback(err)
    #log(file_list);
    tasks = _.map file_list, (file_name) -> (cb) -> fs.unlink dir + file_name, cb
    async.parallel tasks, (err, results) ->
      if err then return callback(err)
      callback null, results.length + ' files deleted.'

appendMessageToFile = (file_path, message, callback) ->
  ensureExistDir path.dirname(file_path), (err) ->
    if err then return callback(err)
    fs.appendFile file_path, message + '\n', callback

getCertBinary = (cert_file_path, callback) ->
  if typeof cert_file_path == 'string'
    fs.readFile cert_file_path, 'base64', (err, cert_binary) ->
      if err then return callback(err)
      if cert_binary
        callback null, cert_binary
      else
        callback 'could\'t get cert_binary: ' + cert_file_path
  else
    callback 'Cert File Path does not exist.'

zipAllFileInDir = (zipped_file_name, dir_path, callback) ->
  exec = require('child_process').exec
  exec 'zip -j ' + zipped_file_name + ' ' + dir_path + '*', (err, stdout, stderr) ->
    if err then return callback(err)
    if stderr
      callback(stderr)
    else
      callback null, stdout

delete_file = fs.unlink

delete_file_if_exists = (file_path, cb)->
  isFile file_path, (err, is_file)->
    if is_file
      delete_file file_path, (err)->
        if err then return cb "err in #{delete_file_if_exists.name}: #{err}"
        cb()
    else
      cb()

mv = (src_file_path, dst_file_path, callback) -> fs.rename src_file_path, dst_file_path, callback

force_mv = (src_file_path, dst_file_path, cb) ->
  delete_file_if_exists dst_file_path, (err)->
    if err then return cb "err in overwrite, delete file: src: #{src_file_path} dst: #{dst_file_path}  err: #{err}"
    mv src_file_path, dst_file_path, (err)->
      if err then return cb "err in overwrite, mv: src: #{src_file_path} dst: #{dst_file_path}  err: #{err}"
      cb()

force_mv_if_exists = (src_file_path, dst_file_path, cb)->
  isFile src_file_path, (err, is_file)->
    if err then return cb "err in overwrite_if_exists, isFile: src: #{src_file_path} dst: #{dst_file_path}  err: #{err}"
    if is_file
      force_mv src_file_path, dst_file_path, cb
    else
      cb()

module.exports =
  isFile: isFile
  isDir: isDir
  fs: fs
  path: path
  writeFile: fs.writeFile
  prepareDir: ensureExistDir
  ensureExistDir: ensureExistDir
  catalogueDir: catalogueDir
  delete_file: delete_file
  delete_file_if_exists: delete_file_if_exists
  delAllFilesInDir: delAllFilesInDir
  mv: mv
  force_mv: force_mv
  force_mv_if_exists: force_mv_if_exists
  prepareCleanDir: prepareCleanDir
  readAsUtf8: readAsUtf8
  appendMessageToFile: appendMessageToFile
  getCertBinary: getCertBinary
  zipAllFileInDir: zipAllFileInDir
