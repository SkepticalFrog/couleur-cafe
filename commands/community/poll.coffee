{ log, error, info } = require "../../utils/logs"
{ ApplicationCommandOptionType } = require "discord-api-types/v9"
{ MessageActionRow, MessageButton } = require "discord.js"
_ = require "lodash"

module.exports =
  name: "poll"
  description: "Creates a poll with up to 5 choices"
  options: [
    {
      name: "duration",
      type: ApplicationCommandOptionType.Integer
      required: true
      description: "How long to keep the poll running (max 24h)"
    }
    {
      name: "title"
      type: ApplicationCommandOptionType.String
      required: true
      description: "Title of the poll"
    }
    {
      name: "option1" 
      type: ApplicationCommandOptionType.String
      required: true
      description: "Pool choice 1"
    }
    {
      name: "option2" 
      type: ApplicationCommandOptionType.String
      required: true
      description: "Pool choice 2"
    }
    {
      name: "option3" 
      type: ApplicationCommandOptionType.String
      required: false
      description: "Pool choice 3"
    }
    {
      name: "option4" 
      type: ApplicationCommandOptionType.String
      required: false
      description: "Pool choice 4"
    }
    {
      name: "option5" 
      type: ApplicationCommandOptionType.String
      required: false
      description: "Pool choice 5"
    }
  ]
  execute: (interaction) ->
    { options } = interaction

    await interaction.defer { ephemeral: false }
    rows = []
    choices = options.data.filter (option) -> option.name.startsWith "option"

    for option in choices
      rows.push(
        new MessageActionRow()
          .addComponents(
            new MessageButton()
              .setCustomId option.name
              .setLabel option.value
              .setStyle "SECONDARY"
          )
      )

    await interaction.editReply
      content: options.getString "title"
      components: rows


    try
      users = []
      # duration = _.clamp options.getInteger("duration"), 600
      duration = options.getInteger("duration")
      message = await interaction.fetchReply()
      user = interaction.user

      filter = (i) ->
        if not users.includes i.user.id
          users.push i.user.id
          await i.reply
            content: "Merci pour le vote !"
            ephemeral: true
          return true
        else
          await i.reply
            content: "Déjà voté !"
            ephemeral: true
          return false

      collector = interaction.channel.createMessageComponentCollector { filter, time: duration * 1000 }

      while not collector.ended
        clicked = await collector.next

    catch err
      if not err?.size?
        throw err

      collected = err

      fields = choices.map (choice) ->
        votes = collected.filter (element) -> element.customId is choice.name
          .size
        {
          name: choice.value
          value: "#{votes} vote(s)."
          votes
          id: choice.name
        }
      winners = fields.sort((a, b) -> b.votes - a.votes)
      if winners[0].votes != winners[1].votes
        winner = options.getString winners[0].id
      

      embed = {
        color: 0xff6600
        title: if winner then "\"#{winner}\" a été l'option la plus votée !" else "Égalité !" 
        footer: { text: "Powered by SkepticalFrog™" }
        author:
          name: options.getString "title"
        thumbnail:
          url: user.displayAvatarURL()
        fields
        description: "Il y a eu #{collected.size} votes en #{duration} secondes de vote."
      }

      return await message.edit
        content: "Fin du sondage."
        embeds: [embed]
        components: []
