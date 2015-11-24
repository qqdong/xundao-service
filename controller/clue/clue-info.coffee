whenjs = require 'when'

Error_code = require('../../lib/error_code.coffee')
Service_clueInfo = require('../../service/clue/clue-info.coffee')
Permission = require('../base/permission.coffee')
Check = require('../base/check-params.coffee')
{Role}=require('../../model/user/role.coffee')
Result_Clue = require('../../result/clue.coffee')

#发布线索信息
#sex,begin_age,end_age,height,clothes,feature,pictures,see_date,see_place_province,see_place_city,
#see_place_area,see_place_detail,description
exports.publish = (req, res, next)->
  params = req.body

  Check.checkNull(params, ['pictures',
                           'missing_place_province', 'missing_place_city', 'missing_place_area', 'missing_place_detail'
  ])

  Permission.asynCheckRole(req, Role.Register)
  .then ()->
    params.user_id = req.uid
    Service_clueInfo.publishClueInfo(params)
  .done (infoModel)->
    res.json
      clue_id: infoModel.getId()
  , next

exports.update = (req, res, next)->
  params = req.body
  Check.checkNull(params, ['info_id'])
  Permission.asynCheckRole(req, Role.Register)
  .then ()->
    Service_clueInfo.updateClueInfo(params)
  .done (infoModel)->
    res.json
      clue_id: infoModel.getId()
  , next

exports.list = (req, res, next)->
  params = req.body
  {skip,max} = params
  params.skip = parseInt(skip) || 0
  params.max = parseInt(max) || 10

  result = []
  Permission.asynCheckRole(req, Role.UnRegister)
  .then ()->
    Service_clueInfo.listClueInfo(params)
  .then (infoModelList)->
    result = Result_Clue.getInfoList(infoModelList)
  .done ()->
    res.json result
  , next

exports.detail = (req, res, next)->
  {info_id} = req.body
  Check.checkNull(req.body, ["info_id"])

  Permission.asynCheckRole(req, Role.UnRegister)
  .then ()->
    Service_clueInfo.getClueInfoById(info_id)
  .then (infoModel)->
    throw Error_code.clueError.clueIdInvalid unless  infoModel?
    Result_Clue.asyncGetInfoDetail(infoModel)
  .done (result)->
    res.json result
  , next