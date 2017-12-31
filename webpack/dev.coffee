path = require 'path'
config = require 'config'
module.exports = (env)->
  devtool: 'eval-source-map'
  entry:
    main: path.join __dirname, "../src/client/index.coffee"
  output:
    path: path.join __dirname, "../dist/static#{config.url_root}"
    filename: "main.js"
    publicPath: "/static#{config.url_root}"
  module:
    loaders: [
      test: /\.coffee$/
      loader: "coffee-loader"
    ,
      test: /\.css$/
      loader: "style-loader!css-loader"
    ,
      test: /\.less$/
      loader : 'style-loader!css-loader!less-loader'
    ,
      test: /\.(png|woff|woff2|eot|ttf|svg)$/
      loader: 'url-loader?limit=100000'
    ,
      test: /\.jsx$/
      loader: "babel-loader"
    ]
