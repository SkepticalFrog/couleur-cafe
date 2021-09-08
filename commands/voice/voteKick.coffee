{ log, error, info } = require "../../utils/logs"
{ ApplicationCommandOptionType } = require "discord-api-types/v9"
{ MessageActionRow, MessageButton } = require "discord.js"

module.exports = 
  name: "vote-kick"
  description: "Vote to kick a user from the voice channel"
  options: [
    {
      name: "user"
      type: ApplicationCommandOptionType.User
      description: "User to kick"
      required: true
    }
  ]
  execute: (interaction) ->
    { options } = interaction
    await interaction.defer { ephemeral: true }

    userToKick = options.getUser "user"
    demander = interaction.user

    info 2, "1", userToKick.username
    info 2, "2", demander.username

    row = new MessageActionRow()
      .addComponents(
        new MessageButton()
          .setCustomId "confirm"
          .setLabel "Oui"
          .setStyle "SUCCESS"
      )
      .addComponents(
        new MessageButton()
          .setCustomId "cancel"
          .setLabel "Non"
          .setStyle "DANGER"
      )

    await interaction.editReply
      content: "Doit-on kick #{userToKick} du vocal ?"
      components: [row]