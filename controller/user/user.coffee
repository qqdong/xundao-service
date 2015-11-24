whenjs = require 'when'

Error_code = require('../../lib/error_code.coffee')
Service_User = require('../../service/user/user.coffee')
Lib_sms = require('../../lib/sms.coffee')
Result_User = require('../../result/user.coffee')
Permission = require('../base/permission.coffee')
{Role}=require('../../model/user/role.coffee')
oss = require('../../lib/oss-client.coffee')
Check = require('../base/check-params.coffee')

#发送验证码
exports.sendVerifyCode = (req, res, next)->
  {mobile}=req.body
  Check.checkNull(req.body, ['mobile'])

  Permission.asynCheckRole(req, Role.UnRegister)
  .then ()->
    Lib_sms.send mobile, null
  .done ()->
    res.json
      mobile: mobile
      result: '发送成功'
  , next

#上传文件
exports.uploadFile = (req, res, next)->
  Permission.asynCheckRole(req, Role.Register)
  .then ()->
    {file} = req.files || []
    throw Error_code.commonError.parameterError unless  file?
    oss.upload(file, req.uid)
  .done (url)->
    res.json
      url: url
  , next

#获取用户信息
exports.getById = (req, res, next)->
  {user_id}=req.body
  Check.checkNull(req.body, ['user_id'])

  result = {}
  Permission.asynCheckRole(req, Role.UnRegister)
  .then ()->
    Service_User.getUserById(user_id)
  .then (userModel)->
    throw Error_code.userError.uidInvalid unless userModel
    result = Result_User.getUserInfo(userModel)
  .done ()->
    res.json result
  , next

#更新信息
exports.update = (req, res, next)->
  {nick_name,description,head_img}=req.body

  throw  Error_code.commonError.parameterError unless (nick_name? or description? or head_img?)

  result = {}
  Permission.asynCheckRole(req, Role.Register)
  .then ()->
    Service_User.updateUserById(req.uid, nick_name, description, head_img)
  .then (userModel)->
    result = Result_User.getUserInfo(userModel)
  .done ()->
    res.json result
  , next