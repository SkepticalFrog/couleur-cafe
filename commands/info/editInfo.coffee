User = require "../../db/schemas/User"
{ log, error, info } = require "../../utils/logs"
{ ApplicationCommandOptionType } = require "discord-api-types/v9"
moment = require "moment"

module.exports =
  name: "edit-info"
  description: "Saves user's info"
  options:
    [
      {
        name: "lastname"
        type: ApplicationCommandOptionType.String
        description: "Lastname of user"
        required: false
      }
      {
        name: "firstname"
        type: ApplicationCommandOptionType.String
        description: "Firstname of user"
        required: false
      }
      {
        name: "email"
        type: ApplicationCommandOptionType.String
        description: "Email of user"
        required: false
      }
      {
        name: "phone_number"
        type: ApplicationCommandOptionType.String
        description: "Lastname of user"
        required: false
      }
      {
        name: "birthdate"
        type: ApplicationCommandOptionType.String
        description: "Birth date of user (YYYY-MM-DD)"
        required: false
      }
    ]
  execute: (interaction, client) ->
    { options } = interaction

    try
      await interaction.defer {ephemeral: true}

      id = interaction.user.id
      full_id = id + "_" + interaction.guild.id

      tempUser = options.data.reduce (obj, option) ->
        if option.name is "birthdate"
          birthdate = moment options.getString("birthdate")
          if not birthdate.isValid()
            throw new Error "INVALID_DATE"

          obj[option.name] = birthdate.format()
        else
          obj[option.name] = option.value
        return obj
      , {}

      user = await User.findById full_id

      if not user?
        return await interaction.editReply "L'utilisateru n'existe pas."

      res = await user.updateOne {
        $set: {
          tempUser...
          updated_at: Date.now()
        }
      },
        new: true
      
      if not res.n is 1
        return await interaction.editReply "L'utilisateur n'a pas pu être modifié."

      await interaction.editReply
        content: "<@#{id}> modifié !"
        ephemeral: false

    catch err
      error err
      if err.message is "INVALID_DATE"
        return await interaction.editReply "La date ne suit pas un format valide."
      await interaction.editReply "Eh ben ça a merdé."