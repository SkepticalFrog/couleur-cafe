mongoose = require 'mongoose'

reqString =
  type: String
  required: true

UserSchema = mongoose.Schema {
  _id: reqString
  guilds:
    type: [String]
    default: []
  firstname: reqString
  lastname: reqString
  description:
    type: String
    default: ''
  phone_number: reqString
  birthday:
    type: Date
    required: true
  email: reqString
  flz:
    type: Number
    default: 0
}

module.exports = mongoose.model 'User', UserSchema
