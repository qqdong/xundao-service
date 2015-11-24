AV = require('leanengine')
whenjs = require 'when'

Error_code = require('../../lib/error_code.coffee')
Model_User = require('../../model/user/user.coffee')


#手机号登陆
exports.loginWithMobile = (mobile, password, userAngent)->
  userModel = new Model_User()
  whenjs().then ()-> #登录
    AV.User.logIn(mobile, password)
    .then (table_user)->
      userModel.initByTableUser(table_user)
  .then ()-> #更新用户Token
    userModel.setTokenTime(userAngent)
    userModel.save()
  .then ()->
    return userModel
  .catch (error)->
    throw  error


