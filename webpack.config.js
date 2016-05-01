var path = require('path');

module.exports = {
  entry: './src/js/main.js',
  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'bundle.js'
  },
  devtool: 'inline-source-map',
  module: {
    loaders: [
      {
        test: path.join(__dirname, 'src/js'),
        loader: 'babel-loader'
      }
    ]
  }
};
