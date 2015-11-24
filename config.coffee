_ = require("underscore")
path = require("path")

stageConfig =
  development:
    port: 6301
    #leanengine 配置
    avAppId: 'r8642fg2ifhups1yr57ulrqfb3fltmwvx82kslfip4llszzi'
    avAppKey: 'nbxv7vvmkn77gi9spt7qtbh50yx0g1kipedzkl15n613yhbu'
    avMasterKey: 'd9a1wolcn0obo3b8ag7hj7w6u6jc89haztqf0es2lxyv1ljf'


  production:
    port: process.env.LC_APP_PORT
    #leanengine 配置
    avAppId: process.env.LC_APP_ID
    avAppKey: process.env.LC_APP_KEY
    avMasterKey: process.env.LC_APP_MASTER_KEY


config =
  port: 80

#process.env.NODE_ENV为当前应用环境，测试环境为stage，生产环境为production，开发环境没有该环境变量
if(process.env.NODE_ENV?)
  env="production"
else
  env="development"

module.exports = exports = _.extend(config, stageConfig[env])

exports.env = env
