User = require "../../db/schemas/User"
{ log, error, info } = require "../../utils/logs"
{ ApplicationCommandOptionType } = require "discord-api-types/v9"
moment = require "moment"
{ MessageEmbed } = require "discord.js"

module.exports =
  name: "info"
  description: "Shows info about a user or all users"
  options: [
    {
      name: "user"
      description: "User to display | DON'T USE WIP"
      type: ApplicationCommandOptionType.User
      required: false
    }
  ]
  execute: (interaction, client) ->
    { options } = interaction
    await interaction.defer { ephemeral: true }

    if (user = options.getUser("user"))?
      userData = await User.findById user.id + "_" + interaction.guild.id

      if not userData?
        return await interaction.editReply "L'utilisateur n'a pas été trouvé en base..."
      embed =
        color: 0xff6600
        title: userData.lastname + ' ' + userData.firstname
        footer: { text: userData.email }
        author: {
          name: "#{user.username}##{user.discriminator}"
        }
        thumbnail: {
          url: user.displayAvatarURL()
        }
        fields: [
          {
            name: 'Numéro'
            value: userData.phone_number
            inline: true
          }
          {
            name: 'Anniversaire'
            value: moment(userData.birthdate).format('D/MM/YYYY')
            inline: true
          }
        ]
        description: userData.description

      return await interaction.editReply
        embeds: [embed]

    users = await User.where "_id", /// .+_#{interaction.guild.id} ///gi

    embed = new MessageEmbed()
      .setColor 0x00cc22
      .setTitle "Liste des utilisateurs enregistrés"
      .setThumbnail interaction.client.user.displayAvatarURL()
      .setFooter "Powered by SkepticalFrog™"
      .addFields users.map (userData) ->
        id = userData.id.split("_")[0]
        return {
          name:
            "@" +
            interaction.guild.members.cache.get(id).user.username +
            "#" +
            interaction.guild.members.cache.get(id).user.discriminator
          value:
            userData.lastname +
            " " +
            userData.firstname +
            " : " +
            userData.email +
            ", " +
            userData.phone_number +
            " né le " +
            moment(userData.birthdate).format "D/MM/YYYY"
        }

    await interaction.editReply
      embeds: [embed]


