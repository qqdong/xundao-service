whenjs = require 'when'
request = require 'request'
multipart = require 'connect-multiparty'

express = require 'express'
router = express.Router()

Controller_User = require('../controller/user/user.coffee')
Controller_Login = require('../controller/user/login.coffee')
Controller_Register = require('../controller/user/register.coffee')

#发送验证码
router.post '/sendVerifyCode', Controller_User.sendVerifyCode
#上传文件
router.post '/uploadFile', multipart(), Controller_User.uploadFile

#注册
router.post '/registerWithMobile', Controller_Register.registerWithMobile
#登录
router.post '/loginWithMobile', Controller_Login.loginWithMobile
#根据用户Id获取用户
router.post '/getById', Controller_User.getById
#更新用户信息
router.post '/update', Controller_User.update

module.exports = exports = router