padding = (num)-> ('0' + num).slice(-2)
getDateJaOrder = (date)->
  y = date.getFullYear()
  m = date.getMonth()+1
  d = date.getDate()
  H = date.getHours()
  M = date.getMinutes()
  S = date.getSeconds()

  [
    y
    padding(m)
    padding(d)
    padding(H)
    padding(M)
    padding(S)
  ]

toJaString = (date)->
  if date? and typeof date.getFullYear=='function'
    ja = getDateJaOrder date
    ja[0] + '/' + ja[1] + '/' + ja[2] + ' ' + ja[3] + ':' + ja[4] + ':' + ja[5]
  else
    ''
toJaDateString = (date)->
  ja_string = toJaString date
  if ja_string==''
    ''
  else
    ja_string.slice 0, 10

toJaNumber = (date)->
  if date? and typeof date.getFullYear=='function'
    ja = getDateJaOrder date
    ja.join ''
  else
    return ''

module.exports =
  toJaString: toJaString
  toJaDateString: toJaDateString
  toJaNumber: toJaNumber
