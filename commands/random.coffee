module.exports =
  name: "random"
  description: "oaizefoiazefoipj"
  execute: (interaction, client) ->
    await interaction.defer()
    await setTimeout (->
      await interaction.editReply "Yolo."
    ), 5000 