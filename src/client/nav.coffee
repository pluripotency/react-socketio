h = require 'react-hyperscript'
React = require 'react'
ReactRouter = require 'react-router-dom'
Link = ReactRouter.Link

class nav extends React.Component
  constructor: (props)->
    super(props)
    @state =
      navbar_toggle: false
    document.title = props.title
  toggle: ()=>
    @setState navbar_toggle: !@state.navbar_toggle
  render: ()=>
    h "nav.navbar.navbar-default", [
      h '.container-fluid', [
        h '.navbar-header', [
          h 'button.navbar-toggle',
            onClick: @toggle
          , [
            h 'span.icon-bar'
            h 'span.icon-bar'
            h 'span.icon-bar'
          ]
          h '.navbar-brand', [
            "#{@props.title} "
          ]
        ]
        h '.navbar-collapse',
          className: if @state.navbar_toggle then 'in' else 'collapse'
        , [
            h 'ul.nav.navbar-nav', @props.vm.nav_items.map (item)=>
              h 'li',
                className: if window.location.pathname==item.url then 'active'
                onClick: ()=>
              , [
                  h Link, to: item.url , item.name
                ]
          ]
      ]
    ]

module.exports = nav
