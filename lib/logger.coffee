log4js = require 'log4js'
path = require 'path'

config = require '../config'

logConfig =
  if config.env == 'development'
    appenders: [
      type: 'console'
    ]
    levels:
      "[all]": "DEBUG"
  else
    appenders: [
      type: "file"
      filename: path.join config.logDir, "app.log"
      maxLogSize: 1024 * 1024 * 5
      backups: 10
    ]
    levels:
      "[all]": "ERROR"

log4js.configure logConfig

module.exports = exports = (name) ->
  if name?.indexOf(process.cwd()) == 0
    name = name.substr(process.cwd().length)
  log4js.getLogger name
