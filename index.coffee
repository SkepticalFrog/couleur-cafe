fs = require "fs"
{ log, error, info } = require "./utils/logs"
{ Client, Intents, Collection } = require "discord.js"
{ DTOKEN } = require "config"
deployCommands = require "./deploy"
connectDb = require "./db/connectDb"


client = new Client { intents: [
  Intents.FLAGS.GUILDS
  Intents.FLAGS.GUILD_MESSAGES
  Intents.FLAGS.GUILD_MESSAGE_REACTIONS
  1 << 15 # Intents.FLAGS.MESSAGE_CONTENT
] }
client.commands = new Collection()
client.reaction_commands = new Collection()

commandFolders = fs.readdirSync "./commands"

for folder in commandFolders
  commandFiles = fs.readdirSync "./commands/#{folder}"
    .filter (file) -> file.endsWith ".coffee"

  for file in commandFiles
    command = require "./commands/#{folder}/#{file}"
    info 1, "./commands/#{folder}/#{file}"
    client.commands.set command.name, command

reactionCommands = fs.readdirSync "./reaction_commands"

for file in reactionCommands
  command = require "./reaction_commands/#{file}"
  info 1, "./reaction_commands/#{file}"
  client.reaction_commands.set command.name, command

client.once "ready", ->
  log "Ready!"
  deployCommands client, DTOKEN

client.on "interactionCreate", (interaction) ->
  if not interaction.isCommand()
    return
  if not client.commands.has interaction.commandName
    return
  try
    info 0, "#{interaction.user.username}#" +
      "#{interaction.user.discriminator} " +
      "used command /#{interaction.commandName} " +
      "in server #{interaction.guild.name} " +
      "on ##{interaction.channel.name or "DM channel"}"
    , interaction.options.data.map (option) ->
        { name: option.name, value: option.value}
    await client.commands.get(interaction.commandName).execute(interaction, client);
  catch err
    error err
    await interaction.editReply
      content: "Erreur pendant l'exécution de la commande."
      components: []

client.on "messageReactionAdd", (messageReaction) ->
  log messageReaction.emoji.name
  if not client.reaction_commands.has messageReaction.emoji.name
    return;
  try
    info 0, "#{messageReaction.message.author.username}#" +
      "#{messageReaction.message.author.discriminator} " +
      "used reaction command #{messageReaction.emoji.name} " +
      "in server #{messageReaction.message.guild.name} " +
      "on ##{messageReaction.message.channel.name or "DM channel"}"
    await client.reaction_commands.get(messageReaction.emoji.name).execute(messageReaction, client);
  catch err
    error err

client.login DTOKEN

db = connectDb()
db.on "error", -> error "DB connection error"
db.once "open", ->
  log "Connection to DB established!"
  client.db = db
