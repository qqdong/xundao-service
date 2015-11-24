whenjs = require 'when'

Error_code = require('../../lib/error_code.coffee')
Service_missingInfo = require('../../service/missing/missing-info.coffee')
Permission = require('../base/permission.coffee')
Check = require('../base/check-params.coffee')
{Role}=require('../../model/user/role.coffee')
Result_Missing = require('../../result/missing.coffee')

#发布丢失信息
#name,sex,birth,nation,height,clothes,feature,pictures,missing_date,missing_place_province,missing_place_city,
#missing_place_area,missing_place_detail,description,type_id,promise_money
exports.publish = (req, res, next)->
  params = req.body

  Check.checkNull(params, ['name', 'sex', 'birth', 'nation', 'height', 'clothes', 'pictures', 'missing_date',
                           'missing_place_province', 'missing_place_city', 'missing_place_area', 'missing_place_detail',
                           'type_id', 'promise_money'])

  Permission.asynCheckRole(req, Role.Register)
  .then ()->
    params.user_id = req.uid
    Service_missingInfo.publishMissingInfo(params)
  .done (infoModel)->
    res.json
      missing_id: infoModel.getId()
  , next

exports.update = (req, res, next)->
  params = req.body
  Check.checkNull(params, ['info_id'])
  Permission.asynCheckRole(req, Role.Register)
  .then ()->
    Service_missingInfo.updateMissingInfo(params)
  .done (infoModel)->
    res.json
      missing_id: infoModel.getId()
  , next

exports.list = (req, res, next)->
  params = req.body
  {age,skip,max} = params
  if age? then params.age = parseInt(age)
  params.skip = parseInt(skip) || 0
  params.max = parseInt(max) || 10

  result = []
  Permission.asynCheckRole(req, Role.UnRegister)
  .then ()->
    Service_missingInfo.listMissingInfo(params)
  .then (infoModelList)->
    result = Result_Missing.getInfoList(infoModelList)
  .done ()->
    res.json result
  , next

exports.detail = (req, res, next)->
  {info_id} = req.body
  Check.checkNull(req.body, ["info_id"])

  Permission.asynCheckRole(req, Role.UnRegister)
  .then ()->
    Service_missingInfo.getMissingInfoById(info_id)
  .then (infoModel)->
    throw Error_code.missingError.missingIdInvalid unless infoModel?
    Result_Missing.asyncGetInfoDetail(infoModel)
  .done (result)->
    res.json result
  , next