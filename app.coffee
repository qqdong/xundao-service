config = require('./config.coffee')

#初始化AV
cloud=require './cloud.js'
AV = require('leanengine')

console.log '=================='+config.avAppId+"================="
AV.initialize(config.avAppId, config.avAppKey, config.avMasterKey)
AV.Cloud.useMasterKey()
AV.Promise._isPromisesAPlusCompliant = false

process.chdir(__dirname)

_ = require("lodash")
os = require 'os'
express = require("express")

path = require("path")
compress = require("compression")
require "date-format-lite"
app = express()

#加载云代码方法
app.use(cloud)
app.use(cloud.CookieSession({secret: 'xundao'}))

#注册路由
router = require("./router/index")

#服务健康检查
app.use '/health-check', (req, res) ->
  res.send 'OK'

app.use compress()
app.use router

#启动服务
server = null
http = require("http")
server = http.createServer(app)
server.setMaxListeners 100
server.listen config.port , '0.0.0.0', () ->
  console.log '启动......'

#未捕获异常处理
process.on 'uncaughtException', (err) ->
  console.log err

module.exports = exports = app
