mongoose = require 'mongoose'

reqString =
  type: String
  required: true

ServerSchema = mongoose.Schema {
  _id: reqString
  defaultChannel: reqString
  welcome: String
  botreplies:
    type: [String]
    default: []
}

module.exports = mongoose.model 'Server', ServerSchema
