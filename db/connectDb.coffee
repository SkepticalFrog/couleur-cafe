{ MONGO_URI } = require "config"
mongoose = require "mongoose"

connectDb = () ->
  mongoose.connect MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true }

  db = mongoose.connection

module.exports = connectDb