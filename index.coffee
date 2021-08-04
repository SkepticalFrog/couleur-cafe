fs = require "fs"
{ log, error, info } = require "./utils/logs"
{ Client, Intents, Collection } = require "discord.js"
{ DTOKEN } = require "config"
deployCommands = require "./deploy"
connectDb = require "./db/connectDb"

client = new Client { intents: [Intents.FLAGS.GUILDS, Intents.FLAGS.GUILD_MESSAGES] }
client.commands = new Collection()

commandFolders = fs.readdirSync "./commands"

for folder in commandFolders
  commandFiles = fs.readdirSync "./commands/#{folder}"
    .filter (file) -> file.endsWith ".coffee"

  for file in commandFiles
    command = require "./commands/#{folder}/#{file}"
    info "./commands/#{folder}/#{file}"
    client.commands.set command.name, command

client.once "ready", ->
  log "Ready!"
  deployCommands client, DTOKEN

client.on "interactionCreate", (interaction) ->
  if not interaction.isCommand()
    return;
  if not client.commands.has interaction.commandName
    return;
  try
    await client.commands.get(interaction.commandName).execute(interaction, client);
  catch err
    error err
    await interaction.reply { content: 'There was an error while executing this command!', ephemeral: true }

client.login DTOKEN

db = connectDb()
db.on "error", -> error "DB connection error"
db.once "open", ->
  log "Connection to DB established!"
  client.db = db
