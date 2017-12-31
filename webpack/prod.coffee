webpack = require 'webpack'
path = require 'path'
config = require 'config'
module.exports = (env)->
  entry:
    main: path.join __dirname, "../src/client/index.coffee"
  output:
    path: path.join __dirname, "../dist/static#{config.url_root}"
    filename: "main.js"
  module:
    loaders: [
      test: /\.coffee$/
      loader: "coffee-loader"
    ,
      test: /\.css$/
      loader: "style-loader!css-loader"
    ,
      test: /\.(png|woff|woff2|eot|ttf|svg)$/
      loader: 'url-loader?limit=100000'
    ,
      test: /\.jsx$/
      loader: "babel-loader"
    ]
  plugins: [
    new webpack.DefinePlugin
      'process.env.NODE_ENV': JSON.stringify 'production'
    new webpack.optimize.UglifyJsPlugin {sourceMap: false}
  ]
