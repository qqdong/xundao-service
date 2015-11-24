whenjs = require 'when'

Error_code = require('../../lib/error_code.coffee')

Permission = require('../base/permission.coffee')
Check = require('../base/check-params.coffee')
{Role}=require('../../model/user/role.coffee')

Service_Force = require('../../service/force/force.coffee')
{ForceType}=require('../../model/force/force-type.coffee')
Service_Clue = require('../../service/clue/clue-info.coffee')
Result_Clue = require('../../result/clue.coffee')

#添加关注
exports.add = (req, res, next)->
  params = req.body

  Check.checkNull(params, [
    'clue_id'
  ])

  Permission.asynCheckRole(req, Role.Register)
  .then ()->
    Service_Force.addForce(ForceType.Clue, params.clue_id, req.uid)
  .done ()->
    res.json {}
  , next


#取消关注
exports.cancel = (req, res, next)->
  params = req.body

  Check.checkNull(params, [
    'clue_id'
  ])

  Permission.asynCheckRole(req, Role.Register)
  .then ()->
    Service_Force.cancelForce(ForceType.Clue, params.clue_id, req.uid)
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
    Service_Force.listTargetIdByUserId(ForceType.Clue, req.uid, skip, max)
  .then (idArray)->
    console.log idArray
    whenjs.map idArray, (id, index)->
      Service_Clue.getClueInfoById(id)
      .then (model)->
        result[index] = model
  .then ()->
    console.log result
    result = Result_Clue.getInfoList(result)
  .done ()->
    res.json result
  , next