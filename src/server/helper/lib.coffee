_ = require 'lodash'

getRandomChars = ->
  num_of_chars = 10
  if arguments[0]
    num_of_chars = arguments[0]
  base_chars = _.reduce(_.range(num_of_chars), ((sum, index) ->
    sum + 'x'
  ), '')
  if arguments[1]
    base_chars = arguments[1]
  char_dict = 'dfhkpswxyABCDEFGHJKLMNPQRSTUWXY345789'
  if arguments[2]
    char_dict = arguments[2]
  char_replace_exp = /[xy]/g
  if arguments[3]
    char_replace_exp = arguments[3]
  base_chars.replace char_replace_exp, (c) ->
    char_dict[Math.floor(Math.random() * char_dict.length)]


module.exports =
  _: _
  async: require 'async'
  getRandomChars: getRandomChars
