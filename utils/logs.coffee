term = require "terminal-kit"
  .terminal
moment = require "moment"

timestamp = ->
  "[" + moment().format("DD-MM-YY HH:mm:ss") + "]"

error = (args...) ->
  term.grey timestamp()
  term.red "[-] "
  console.log args...

info = (tabs, args...) ->
  term.grey timestamp()
  for x in [0...tabs]
    term "\t"
  term.blue "[?] "
  console.log args...

log = (args...) ->
  term.grey timestamp()
  term.green "[+] "
  console.log args...

module.exports =
  error: error
  info: info
  log: log