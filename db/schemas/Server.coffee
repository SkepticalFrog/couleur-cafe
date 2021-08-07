mongoose = require 'mongoose'

reqString =
  type: String
  required: true

ServerSchema = mongoose.Schema {
  _id: reqString
  defaultChannel: reqString
  welcome: String
  prefix: String
  unused:
    type: [String]
    default: []
  botreplies:
    type: [String]
    default: []
}

module.exports = mongoose.model 'Server', ServerSchema
