whenjs = require 'when'

Error_code=require('../lib/error_code.coffee')
Service_userRegister=require('../service/user-register.coffee')

exports.registerWithMobile=(req,res,next)->
  {mobile,password}=req.body

  Service_userRegister.registerWithMobile(mobile,password)
  .done (new_user)->
    res.json new_user
  ,next

