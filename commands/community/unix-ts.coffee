{ log, error, info } = require "../../utils/logs"
{ ApplicationCommandOptionType } = require "discord-api-types/v9"

module.exports =
  name: "unix"
  description: "Parses date into unix timestamp."
  options: [
    {
      name: "date"
      type: ApplicationCommandOptionType.String
      description: "The date to parse"
      required: true
    }
  ]
  execute: (interaction) ->
    date_string = interaction.options.getString "date"
    { user } = interaction
    try
      unless isNaN Number date_string
        date = new Date 1000 * Number date_string
      else
        date = new Date Date.parse date_string
      unless typeof date is "object"
        throw "INVALID_DATE"
      if date is null or date is undefined or Object.prototype.toString.call date is not '[object Date]'
        throw "INVALID_DATE"

      embed = {
        color: 0xff6600
        title: date_string
        footer: { text: "Powered by SkepticalFrog™" }
        thumbnail:
          url: user.displayAvatarURL()
        fields: [
          {
            name: "ISO"
            value: date + ""
            id: "iso"
          }
          {
            name: "Unix Timestamp"
            value: "" + date.getTime() / 1000
            id: "unix"
          }
        ]
        description: "Parce que c'est plus joli comme ça."
      }
      await interaction.reply
        embeds: [embed]
        ephemeral: false
    catch e
      error e
      await interaction.reply
        content: "Error during command. Make sure your date format is valid."
        ephemeral: true