User = require "../../db/schemas/User"
{ log, error, info } = require "../../utils/logs"
{ ApplicationCommandOptionType } = require "discord-api-types/v9"
{ MessageActionRow, MessageButton } = require "discord.js"

module.exports =
  name: "delete-info"
  description: "Delete user's info."
  options: []
  execute: (interaction, client) ->
    { options } = interaction
    try
      await interaction.defer { ephemeral: true }
      id = interaction.user.id

      user = await User.findById id + "_" + interaction.guild.id

      if not user?
        return await interaction.editReply "L'utilisateur n'est pas enregistré."

      row = new MessageActionRow()
        .addComponents(
          new MessageButton()
            .setCustomId "confirm"
            .setLabel "Yes"
            .setStyle "SUCCESS"
        )
        .addComponents(
          new MessageButton()
            .setCustomId "cancel"
            .setLabel "No"
            .setStyle "DANGER"
        )

      await interaction.editReply
        content: "Es-tu sûr de vouloir supprimer #{interaction.user} ?"
        components: [row]


      filter = (i) ->
        i.deferUpdate({ ephemeral: true })
        return i.user.id is interaction.user.id

      collector = interaction.channel.createMessageComponentCollector { filter, time: 15000 }

      clicked = await collector.next
      collector.stop("Collected all I need")

      if clicked.customId is "cancel"
        return await interaction.editReply
          content: "Opération annulée"
          components: []

      res = await user.deleteOne()
      if not res?
        return await interaction.editReply "Error while deleting."
      await interaction.editReply
        content: "Utilisateur #{interaction.user} supprimé."
        components: []

    catch err
      error err
      await interaction.editReply 
        content:"Eh ben ça a merdé."
        components: []