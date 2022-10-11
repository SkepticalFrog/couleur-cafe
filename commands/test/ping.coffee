{ log } = module.require "../../utils/logs"

module.exports =
  name: "ping"
  description: "Replies with pong!"
  execute: (interaction, client) ->
    if interaction.user.id is "261222713111085070"
      await interaction.reply {content: "Coucou mon petit Dylan <3", ephemeral: true}
    else
      await interaction.reply {content: "Pong!", ephemeral: true}
