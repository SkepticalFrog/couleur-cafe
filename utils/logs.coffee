term = require "terminal-kit"
  .terminal

error = (args...) ->
  term.red "[-] "
  console.log args...

info = (args...) ->
  term.blue "[?] "
  console.log args...

log = (args...) ->
  term.green "[+] "
  console.log args...

module.exports =
  error: error
  info: info
  log: log