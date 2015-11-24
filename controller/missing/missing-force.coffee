whenjs = require 'when'

Error_code = require('../../lib/error_code.coffee')

Permission = require('../base/permission.coffee')
Check = require('../base/check-params.coffee')
{Role}=require('../../model/user/role.coffee')

Service_Force = require('../../service/force/force.coffee')
{ForceType}=require('../../model/force/force-type.coffee')
Service_Missing = require('../../service/missing/missing-info.coffee')
Result_Missing = require('../../result/missing.coffee')


#添加关注
exports.add = (req, res, next)->
  params = req.body

  Check.checkNull(params, [
    'missing_id'
  ])

  Permission.asynCheckRole(req, Role.Register)
  .then ()->
    Service_Force.addForce(ForceType.Missing, params.missing_id, req.uid)
  .done ()->
    res.json {}
  , next


#取消关注
exports.cancel = (req, res, next)->
  params = req.body

  Check.checkNull(params, [
    'missing_id'
  ])

  Permission.asynCheckRole(req, Role.Register)
  .then ()->
    Service_Force.cancelForce(ForceType.Missing, params.missing_id, req.uid)
  .done ()->
    res.json {}
  , next

#获取关注列表
exports.list = (req, res, next)->
  params = req.body

  skip = parseInt(params.skip) || 0
  max = parseInt(params.max) || 10

  result = []
  Permission.asynCheckRole(req, Role.Register)
  .then ()->
    Service_Force.listTargetIdByUserId(ForceType.Missing, req.uid, skip, max)
  .then (idArray)->
    whenjs.map idArray, (id, index)->
      Service_Missing.getMissingInfoById(id)
      .then (model)->
        result[index] = model
  .then ()->
    result = Result_Missing.getInfoList(result)
  .done ()->
    res.json result
  , next