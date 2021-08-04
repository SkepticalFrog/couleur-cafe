{ log } = require "../../utils/logs"

module.exports =
  name: "check-db"
  description: "Yolo on check"
  execute: (interaction, client) ->
    log client.db
    await interaction.reply "Mon zbi"