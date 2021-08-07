User = require "../../db/schemas/User"
{ log, error, info } = require "../../utils/logs"
{ ApplicationCommandOptionType } = require "discord-api-types/v9"
{ MessageActionRow, MessageButton } = require "discord.js"

module.exports =
  name: "delete-info"
  description: "Delete user's info."
  options: [
    {
      name: "user"
      type: ApplicationCommandOptionType.User
      description: "User to delete."
      required: false
    }
  ]
  execute: (interaction, client) ->
    { options } = interaction
    try
      await interaction.defer({ ephemeral: false })
      if options.getUser("user")?
        id = options.getUser("user").id
      else
        id = interaction.user.id

      user = await User.findById id

      # if not user?
      #   return await interaction.editReply "L'utilisateur n'est pas enregistré."

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
        content: "Es-tu sûr de vouloir supprimer <@#{id}> ?"
        components: [row]


      filter = (i) ->
        i.deferUpdate()
        return (i.user.id is id)

      collector = interaction.channel.createMessageComponentCollector({ filter, time: 15000 });

      clicked = await collector.next
      collector.stop("Collected all I need")

      if clicked.customId is "cancel"
        return await interaction.editReply
          content: "Opération annulée"
          components: []

      res = await User.findByIdAndDelete id
      info res
      await interaction.editReply
        content: "Utilisateur <@#{id}> supprimé."
        components: []

    catch err
      error err
      await interaction.editReply "Eh ben ça a merdé."