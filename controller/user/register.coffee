Error_code = require('../../lib/error_code.coffee')
Service_userRegister = require('../../service/user/register.coffee')
Result_User = require('../../result/user.coffee')
Permission = require('../base/permission.coffee')
{Role}=require('../../model/user/role.coffee')
Check = require('../base/check-params.coffee')

#通过手机注册
exports.registerWithMobile = (req, res, next)->
  {mobile,password,verify_code}=req.body
  Check.checkNull(req.body, ["mobile", "password","verify_code"])

  Permission.asynCheckRole(req, Role.UnRegister)
  .then ()->
    Service_userRegister.registerWithMobile(mobile, password, verify_code)
  .done (userModel)->
    res.json Result_User.getUserInfo(userModel)
  , next