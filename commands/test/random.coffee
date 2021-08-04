module.exports =
  name: "random"
  description: "Je suis un papillon"
  execute: (interaction, client) ->
    await interaction.defer()
    await setTimeout (->
      await interaction.editReply "Yolo."
    ), 5000