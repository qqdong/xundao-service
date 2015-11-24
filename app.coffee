config = require('./config.coffee')
cloud=require './cloud.js'
AV = require('leanengine')

_ = require("lodash")
os = require 'os'
express = require("express")
http = require("http")

path = require("path")
compress = require("compression")
require "date-format-lite"


#初始化AV
AV.initialize(config.avAppId, config.avAppKey, config.avMasterKey)
AV.Cloud.useMasterKey()
AV.Promise._isPromisesAPlusCompliant = false

process.chdir(__dirname)

#初始化express
app = express()

#加载云代码方法
app.use(cloud)
app.use(cloud.CookieSession({secret: 'xundaole',maxAge: 3600000*30,fetchUser:true}))

#注册路由
router = require("./router/index")
app.use compress()
app.use router

#服务健康检查
app.use '/health-check', (req, res) ->
  res.send 'OK'


#创建服务并启动
server = http.createServer(app)
server.setMaxListeners 100
server.listen config.port , '0.0.0.0', () ->
  console.log '服务已经启动......'

#未捕获异常处理
process.on 'uncaughtException', (err) ->
  console.log err

module.exports = exports = app
