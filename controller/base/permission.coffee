whenjs = require 'when'

Error_code = require('../../lib/error_code.coffee')
Service_User = require('../../service/user/user.coffee')
Security = require('../../util/Security.coffee')
{Role}=require('../../model/user/role.coffee')

#用户权限验证
#1.验证成功，将当前用户信息、userAgent赋值到req对象中
#2.验证失败，直接抛出错误信息

exports.asynCheckRole = (req, roleValue)->
  whenjs().then ()->
    if(roleValue == Role.NoCheck)
      return true

    uid = req.get('Auth-Uid')
    apiKey = req.get('Auth-Api-Key')
    token = req.get('Auth-Token')
    userAgent = req.get('User-Agent')

    req.userAgent = userAgent

    #验证apiKey
    _checkApiKey(apiKey)

    if (roleValue == Role.UnRegister)
      return true

    #验证token和role
    _asynCheckTokenAndRole(uid, userAgent, token, roleValue)
    .then (userModel)->
      req.uid = uid
      req.loginUser = userModel


_checkApiKey = (apiKey)->
  throw Error_code.commonError.apiKeyNotFound unless apiKey?


_asynCheckTokenAndRole = (uid, userAgent, token, roleValue)->
  throw Error_code.userError.requireLogin unless  uid?

  Service_User.getUserById(uid)
  .then (userModel)->
    throw Error_code.userError.uidInvalid unless userModel?
    throw Error_code.userError.pulledBlack unless not userModel.isPullBlack()

    #验证token是否正确
    tokenTime = userModel.getTokenTime(userAgent)
    throw  Error_code.userError.requireLogin unless Security.isUserTokenValid(uid, token, tokenTime)
    throw  Error_code.commonError.noPermissions unless  userModel.getRoleId() >= roleValue
    return userModel







