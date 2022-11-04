{ log } = module.require "../../utils/logs"

module.exports =
  name: "slovaque"
  description: "Slovaque!"
  execute: (interaction, client) ->
    await interaction.reply {content: "Fourré au camembert.", ephemeral: false}
