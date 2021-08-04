module.exports =
  name: "ping"
  description: "Replies with pong!"
  execute: (interaction) ->
    await interaction.reply {content: "Pong!", ephemeral: true}