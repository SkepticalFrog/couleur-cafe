{ log, error, info } = require "../utils/logs"
Quote = require "../db/schemas/Quote"


module.exports = {
  name: "🖨️"
  description: "Adding quote to DB"
  execute: (messageReaction, client) ->
    info 1, "Reaction command #{module.exports.name} executed"
    info 1, messageReaction.message.content
    info 1, messageReaction.message.author.id
    info 1, messageReaction.message.channel.guildId
    info 1, messageReaction.message.channel.id

    quote = new Quote
      server: messageReaction.message.channel.guildId
      channel: messageReaction.message.channel.id
      text: messageReaction.message.content
      author: messageReaction.message.author.id

    quote.save (err) ->
      if err
        error err
      else
        info 1, "Quote saved"
        await messageReaction.message.react "✔️"
}