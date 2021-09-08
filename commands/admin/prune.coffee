{ log, info, error } = require "../../utils/logs"
{ ApplicationCommandOptionType } = require "discord-api-types/v9"
{ MessageActionRow, MessageButton } = require "discord.js"

module.exports =
  name: "prune"
  description: "Removes a certain amount of messages in the current channel, or specified channel."
  options: [
    {
      name: "amount"
      type: ApplicationCommandOptionType.Integer
      description: "How many messages to delete"
      required: true
    },
    {
      name: "channel"
      type: ApplicationCommandOptionType.Channel
      description: "Channel where to remove messages"
      required: false
    }
  ]
  execute: (interaction, client) ->
    amount = if interaction.options.getInteger("amount") > 100 then 100 else interaction.options.getInteger("amount")  
    channel = interaction.options.getChannel("channel")
    await interaction.defer { ephemeral: true }

    if amount <= 0
      await interaction.editReply
        content: "Je ne peux pas supprimer moins de 1 message."

    if channel?
      info 0, channel.type
    else
      channel = interaction.channel

    if not channel.isText()
      return interaction.editReply "Il me faut un channel avec des messages écrits, abruti..."

    row = new MessageActionRow()
      .addComponents(
        new MessageButton()
          .setCustomId "confirm"
          .setLabel "Oui"
          .setStyle "SUCCESS"
      ).addComponents(
        new MessageButton()
          .setCustomId "abort"
          .setLabel "Non"
          .setStyle "DANGER"
      )

    await interaction.editReply
      content: "Es-tu sûr de vouloir supprimer les #{amount} derniers messages de <##{channel.id}> ?"
      components: [row]

    filter = (i) ->
      return i.user.id is interaction.user.id

    collector = interaction.channel.createMessageComponentCollector { filter, time: 15000 }

    clicked = await collector.next
    collector.stop "Collected all I need"

    if clicked.customId is "abort"
      return await interaction.editReply
        content: "Opération annulée."
        components: []

    try
      channel = await channel.fetch()
      deletedAmount = await channel.bulkDelete amount, true
      await interaction.editReply
        content: "#{deletedAmount.size} messages ont été supprimés sur <##{channel.id}>"
        components: []
    catch err
      error err
      await interaction.editReply
        content: "Erreur pendant la prune."
        components: []
