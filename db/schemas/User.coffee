mongoose = require 'mongoose'

reqString =
  type: String
  required: true

UserSchema = mongoose.Schema {
  _id: reqString
  firstname: reqString
  lastname: reqString
  description:
    type: String
    default: ""
  phone_number: reqString
  birthdate:
    type: Date
    required: true
  email: reqString
  flz:
    type: Number
    default: 0
  created_at:
    type: Date
    default: Date.now()
  updated_at:
    type: Date
    default: Date.now()
}

module.exports = mongoose.model 'User', UserSchema
