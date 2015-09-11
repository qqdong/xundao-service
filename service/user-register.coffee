AV= require('leanengine')
whenjs = require 'when'

Error_code=require('../lib/error_code.coffee')

parseUser=(user)->
  result={}
  result.mobile=user.attributes.mobilePhoneNumber
  return result

#手机注册
exports.registerWithMobile=(mobile,password,code)->
  user= new AV.User()
  user.set("username", mobile)
  user.set("password", password)
  user.setMobilePhoneNumber(mobile)
  whenjs().then ()->
    user.signUp(null)
  .then (new_user)->
    new_user= parseUser(new_user)
    return new_user
  .catch (error)->
    if(error.code==214)
      throw  Error_code.userError.mobileAlreadyExist
    throw error


#发送手机验证码
sendVerifyCode=(mobile)->
  whenjs().then ()->
    AV.User.requestMobilePhoneVerify(mobile)


