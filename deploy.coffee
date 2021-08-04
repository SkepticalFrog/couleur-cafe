{ log, error, info } = require "./utils/logs"
{ REST } = require "@discordjs/rest"
{ Routes } = require "discord-api-types/v9"

deployCommands = (client, token) ->
  commands = client.commands.map ({ execute, ...data }) -> data; 
  rest = new REST({ version: "9" }).setToken(token);
  try
    info "Started refreshing application (/) commands"
    await rest.put Routes.applicationGuildCommands(client.user.id, "836505699314958336"), { body: commands }
    # await rest.put Routes.applicationCommands(client.user.id), { body: commands }
    # await client.guilds.cache.get('123456789012345678')?.commands.create(data)
    log "Sucessfully reloaded application (/) commands."
  catch err
    error err

module.exports = deployCommands