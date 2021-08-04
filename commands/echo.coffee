{ ApplicationCommandOptionType } = require "discord-api-types/v9"

module.exports =
  name: "echo"
  description: "Echoes the user input."
  options: [
    {
      name: "input"
      type: ApplicationCommandOptionType.String
      description: "The input to echo"
      required: true
    }
  ]
  execute: (interaction) ->
    await interaction.reply interaction.options.getString "input"