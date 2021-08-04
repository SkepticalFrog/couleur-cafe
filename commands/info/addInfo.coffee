User = require "../../db/schemas/User"
{ log, error, info } = require "../../utils/logs"
{ ApplicationCommandOptionType } = require "discord-api-types/v9"

module.exports =
  name: "add-info"
  description: "Saves user's info"
  options:
    [
      {
        name: "lastname"
        type: ApplicationCommandOptionType.String
        description: "Lastname of user"
        required: true
      },
      {
        name: "firstname"
        type: ApplicationCommandOptionType.String
        description: "Firstname of user"
        required: true
      },
      {
        name: "email"
        type: ApplicationCommandOptionType.String
        description: "Email of user"
        required: true
      },
      {
        name: "number"
        type: ApplicationCommandOptionType.String
        description: "Lastname of user"
        required: true
      },
      {
        name: "birthdate"
        type: ApplicationCommandOptionType.String
        description: "Birth date of user (YYYY-MM-DD)"
        required: true
      },
      {
        name: "user"
        type: ApplicationCommandOptionType.User
        description: "User to save"
        required: false
      }
    ]
  execute: (interaction, client) ->
    log "Okay let's go"
    await interaction.reply "Bon j'avoue ça marche pas encore"