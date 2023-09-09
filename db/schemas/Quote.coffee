mongoose = require 'mongoose'

reqString =
  type: String
  required: true

QuoteSchema = mongoose.Schema {
  server: reqString
  author: reqString
  channel: reqString
  text:
    type: String
    default: ""
  created:
    type: Date
    default: Date.now
}

module.exports = mongoose.model 'Quote', QuoteSchema
