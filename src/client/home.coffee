h = require 'react-hyperscript'
React = require 'react'

class main extends React.Component
  render: ()->
    h 'div', [
      h 'h4', 'test'
    ]

module.exports = main

