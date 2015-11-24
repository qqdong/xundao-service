Error_code = require('../../lib/error_code.coffee')
Service_User_Login = require('../../service/user/login.coffee')
Result_User = require('../../result/user.coffee')
Security = require('../../util/Security.coffee')
Permission = require('../base/permission.coffee')
{Role}=require('../../model/user/role.coffee')
Check = require('../base/check-params.coffee')

#通过手机登录
exports.loginWithMobile = (req, res, next)->
  {mobile,password}=req.body
  Check.checkNull(req.body, ["mobile", "password"])
  result = {}

  Permission.asynCheckRole(req, Role.UnRegister)
  .then ()->
    Service_User_Login.loginWithMobile(mobile, password)
  .then (userModel)->
    result = Result_User.getUserInfo(userModel)
    result.token = Security.getEncodeToken(userModel.getId(), userModel.getTokenTime(req.userAgent))
  .done ()->
    res.json result
  , next