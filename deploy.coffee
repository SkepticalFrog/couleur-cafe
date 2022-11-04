{ log, error, info } = require "./utils/logs"
{ REST } = require "@discordjs/rest"
{ Routes } = require "discord-api-types/v9"

deployCommands = (client, token) ->
  commands = client.commands.map ({ execute, ...data }) -> data; 
  rest = new REST({ version: "9" }).setToken(token);
  try
    info 0, "Started deleting old application (/) commands"
    guilds = await client.guilds.cache

    await Promise.all(
      guilds.map (guild) ->
        await rest.put Routes.applicationGuildCommands(client.user.id, guild.id)
          , { body: [] }
    )
    info 0, "Successfully deleted application (/) commands"
    info 0, "Started refreshing application (/) commands"

    await Promise.all(
        guilds.map (guild) ->
          await rest.put Routes.applicationGuildCommands(client.user.id, guild.id), { body: commands }
          info 1, "Successfully reloaded application (/) commands in guild " + guild.name
    )
    
    # await rest.put Routes.applicationCommands(client.user.id), { body: commands }
    # await client.guilds.cache.get('123456789012345678')?.commands.create(data)
    log "Sucessfully reloaded application (/) commands."
  catch err
    error err

module.exports = deployCommands