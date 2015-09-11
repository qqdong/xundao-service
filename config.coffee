_ = require("underscore")
path = require("path")

stageConfig =
  development:
    port: 6301
    logDir: path.join(process.cwd(), "~/Document/logs")
    shangbaoBaseUrl: 'http://test.goodmore.cn'
    mc:
      locations: 'dev.weimai.com:11211'
      options:
        expires: 3600 * 24
      userPrefix: 'DEV_MUSE_140_'
    paymentService: 'http://muse-dev.weimai.com:903'
    designerUrl: 'https://muse-dev.weimai.com:906'
    partnerId: 'muse'
    signKey: 20150422001
    blockIp: 0
    useHttps: 1
    avAppId: 'r8642fg2ifhups1yr57ulrqfb3fltmwvx82kslfip4llszzi'
    avAppKey: 'nbxv7vvmkn77gi9spt7qtbh50yx0g1kipedzkl15n613yhbu'
    avMasterKey: 'd9a1wolcn0obo3b8ag7hj7w6u6jc89haztqf0es2lxyv1ljf'


  production:
    port: process.env.LC_APP_PORT
    logDir: "/data1/logs/xundao-node-service"
    mc:
    #locations: '26918b37080211e4:eW91c2hla2VqaQ@26918b37080211e4.m.cnqdalicm9pub001.ocs.aliyuncs.com:11211'
      locations: '3bb0dac65df442d4:fynNdgagf7@3bb0dac65df442d4.m.cnqdalicm9pub001.ocs.aliyuncs.com:11211'
      options:
        expires: 3600 * 24
      userPrefix: 'PRODUCTION_ONLINE_135_'
    blockIp: 0
    useHttps: 0
    paymentService: 'https://muse.weimai.com:903'
    designerUrl: 'https://muse-designer.weimai.com'
    partnerId: 'muse'
    signKey: 20150422001
    avAppId: process.env.LC_APP_ID
    avAppKey: process.env.LC_APP_KEY
    avMasterKey: process.env.LC_APP_MASTER_KEY


config =
  port: 80
  oss:
    accessKeyId: 'AexdiY5fcNq3mLqQ'
    accessKeySecret: 'WpAiSiFbsCwWpGOwT3rNDfaEJfn62p'
    host: 'oss-cn-qingdao.aliyuncs.com'
  useSchedule: 1
  smsService: 'http://sms.internal.weimai.com/SendServlet'

if(process.env.NODE_ENV?)
  env="production"
else
  env="development"

#env = process.env.NODE_ENV or "development"

module.exports = exports = _.extend(config, stageConfig[env])
exports.env = env
