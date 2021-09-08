User = require "../../db/schemas/User"
{ log, error, info } = require "../../utils/logs"
{ ApplicationCommandOptionType } = require "discord-api-types/v9"
moment = require "moment"

module.exports =
  name: "add-info"
  description: "Saves user's info"
  options:
    [
      {
        name: "lastname"
        type: ApplicationCommandOptionType.String
        description: "Lastname of user"
        required: true
      }
      {
        name: "firstname"
        type: ApplicationCommandOptionType.String
        description: "Firstname of user"
        required: true
      }
      {
        name: "email"
        type: ApplicationCommandOptionType.String
        description: "Email of user"
        required: true
      }
      {
        name: "phone_number"
        type: ApplicationCommandOptionType.String
        description: "Phone number of user"
        required: true
      }
      {
        name: "birthdate"
        type: ApplicationCommandOptionType.String
        description: "Birth date of user (YYYY-MM-DD)"
        required: true
      }
    ]
  execute: (interaction, client) ->
    { options } = interaction
    try
      await interaction.defer { ephemeral: true }
      guildId = interaction.guild.id
      if options.getUser("user")?
        id = options.getUser("user").id
      else
        id = interaction.user.id

      user = await User.findById id + "_" + guildId

      if user?
        return await interaction.editReply "L'utilisateur existe déjà."

      birthdate = moment.utc options.getString("birthdate")

      if not birthdate.isValid()
        return await interaction.editReply
          content: "Le format de la date est incorrect, veuillez vous référer aux indications fournies."

      user = new User {
        _id: id + "_" + guildId
        lastname: options.getString "lastname"
        firstname: options.getString "firstname"
        email: options.getString "email"
        phone_number: options.getString "phone_number"
        birthdate: birthdate.format()
      }

      await user.save()
      await interaction.editReply
        content: "#{options.getString "firstname"} #{options.getString "lastname"} enregistré !"

    catch err
      error err
      await interaction.editReply "Eh ben ça a merdé."