User = require "../../db/schemas/User"
{ log, error, info } = require "../../utils/logs"
{ ApplicationCommandOptionType } = require "discord-api-types/v9"

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
      },
      {
        name: "firstname"
        type: ApplicationCommandOptionType.String
        description: "Firstname of user"
        required: true
      },
      {
        name: "email"
        type: ApplicationCommandOptionType.String
        description: "Email of user"
        required: true
      },
      {
        name: "number"
        type: ApplicationCommandOptionType.String
        description: "Lastname of user"
        required: true
      },
      {
        name: "birthdate"
        type: ApplicationCommandOptionType.String
        description: "Birth date of user (YYYY-MM-DD)"
        required: true
      },
      {
        name: "user"
        type: ApplicationCommandOptionType.User
        description: "User to save"
        required: false
      }
    ]
  execute: (interaction, client) ->
    { options } = interaction
    try
      await interaction.defer({ ephemeral: false })
      if options.getUser("user")?
        id = options.getUser("user").id
      else
        id = interaction.user.id

      user = await User.findById id

      if user?
        if user.guilds.includes interaction.guild.id
          return await interaction.editReply "L'utilisateur existe déjà."

        user.guilds.push interaction.guild.id
        await user.save()
        return await interaction.editReply "Utilisateur ajouté au serveur !"
      
      user = new User {
        _id: id
        lastname: options.getString "lastname"
        firstname: options.getString "firstname"
        email: options.getString "email"
        phone_number: options.getString "number"
        birthday: options.getString "birthdate"
      }
      user.guilds.push interaction.guild.id

      await user.save()
      await interaction.editReply
        content: "#{options.getString "firstname"} #{options.getString "lastname"} enregistré !"
        ephemeral: false

    catch err
      error err
      await interaction.editReply "Eh ben ça a merdé."