Quote = require "../../db/schemas/Quote"
{ log, error, info } = require "../../utils/logs"
{ ApplicationCommandOptionType } = require "discord-api-types/v9"
{ MessageEmbed } = require "discord.js"

module.exports = 
  name: "quote"
  description: "Display a quote from the database"
  options: [
    {
      name: "author"
      type: ApplicationCommandOptionType.User
      description: "Author of the quote"
      required: false
    }
    {
      name: "last"
      type: ApplicationCommandOptionType.Boolean
      description: "Last quote ?"
      required: false
    }
  ]
  execute: (interaction, client) ->
    { options } = interaction
    await interaction.defer { ephemeral: false }

    author = options.getUser "author"
    last = options.getBoolean "last"

    info 2, "1", author?.id
    info 2, "2", last

    if last and author
      quote = await Quote.findOne { author: author.id }, {}, { sort: { 'created' : -1 } }
    
    else if last
      quote = await Quote.findOne {}, {}, { sort: { 'created' : -1 } }

    else if author
      quotes = await Quote.find { author: author.id }
      quote = quotes[Math.floor(Math.random() * quotes.length)]
    else
      quotes = await Quote.find {}
      quote = quotes[Math.floor(Math.random() * quotes.length)]

    member = await interaction.guild.members.fetch quote.author
    user = member.user
  
    if quote
      embed = 
        color: 0x00ad02
        title: quote.text
        footer: { text: "Powered by SkepticalFrog™" }
        author: {
          name: member.nickname or member.displayName
        }
        thumbnail: {
          url: user.displayAvatarURL()
        }
      await interaction.editReply
        embeds: [embed]
    else
      await interaction.editReply
        content: "No quote found"

