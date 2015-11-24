AV = require('leanengine')
whenjs = require 'when'

Error_code = require('../../lib/error_code.coffee')
Model_User = require('../../model/user/user.coffee')
Table_User = require('../../avos/table/user.coffee')
{UserState}=require('../../model/user/user-state.coffee')

verifyCode = (mobile, code)->
  whenjs().then ()->
    AV.Cloud.verifySmsCode(code, mobile)


#手机号注册
exports.registerWithMobile = (mobile, password, code)->
  verifyCode(mobile, code)#验证手机帐号
  .then ()->
    user = new AV.User()
    user.set("password", password) #此处不需要加密，avos会在服务端自动加密
    user.set("username", mobile)
    user.set("nick_name", getDefaultNickNameOfMobile(mobile))
    user.set("state",UserState.Normal)
    user.setMobilePhoneNumber(mobile)
    user.signUp(null)
  .then (table_user)->
    userModel = new Model_User()
    userModel.initByTableUser(table_user)
    return userModel

getDefaultNickNameOfMobile = (mobile)->
  nickName = mobile.substr(0, 3) + 'xxxx' + mobile.substr(7)
  return nickName