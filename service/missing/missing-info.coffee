AV = require('leanengine')
whenjs = require 'when'

Error_code = require('../../lib/error_code.coffee')
Model_MissingInfo = require('../../model/missing/missing-info.coffee')
MissingState = require('../../model/missing/missing-state.coffee')
Model_MissingType = require('../../model/missing/missing-type.coffee')
MyDate = require('../../util/MyDate.coffee')
Table_MissingInfo = require('../../avos/table/missing-info.coffee')
Table_User = require('../../avos/table/user.coffee')

#发布丢失信息
exports.publishMissingInfo = (params)->
  info = new Table_MissingInfo.MissingInfo()
  whenjs().then ()->
    Table_User.getById(params.user_id)
  .then (user)->
    _setDatasToMissingInfo(info, params)
    info.set('ref_publisher', user) #关联
    info.set('user_id', params.user_id)
    info.set('type_id', params.type_id)
    info.set('promise_money', params.promise_money)
    info.set('info_state', MissingState.MissingInfoState.Showing)
    info.set('find_state', MissingState.MissingFindState.NotFind)

    info.save()
  .then (table_info)->
    infoModel = new Model_MissingInfo()
    infoModel.initByTableMissingInfo(table_info)
    return infoModel

#更新丢失信息
exports.updateMissingInfo = (params)->
  whenjs().then ()->
    Table_MissingInfo.getById(params.info_id)
  .then (info)->
    throw Error_code.missingError.missingIdInvalid unless info?

    _setDatasToMissingInfo(info, params)
    info.set('type_id', params.type_id)
    info.save()
  .then (table_info)->
    infoModel = new Model_MissingInfo()
    infoModel.initByTableMissingInfo(table_info)
    return infoModel

#获取丢失信息列表
exports.listMissingInfo = (params)->
  resultList = []
  query = new AV.Query(Table_MissingInfo.MissingInfo);

  #1.查询条件
  #地区
  if params.missing_place_province then  query.equalTo("missing_place_province", params.missing_place_province)
  if params.missing_place_city then query.equalTo("missing_place_city", params.missing_place_city)
  if params.missing_place_area then query.equalTo("missing_place_area", params.missing_place_area)
  #性别
  if params.sex then query.equalTo("sex", params.sex)
  #丢失时间
  if params.missing_begin_date then query.greaterThanOrEqualTo("missing_date", params.missing_begin_date)
  if params.missing_end_date then query.lessThanOrEqualTo("missing_date", params.missing_end_date)
  #年龄
  if params.missing_begin_age? then query.greaterThanOrEqualTo("birth",
    MyDate.getBirthDateByAge(params.missing_begin_age))
  if params.missing_end_age? then query.lessThanOrEqualTo("birth", MyDate.getBirthDateByAge(params.missing_end_age))
  #状态,只显示showing
  query.equalTo('info_state', MissingState.MissingInfoState.Showing)

  #2.排序
  if params.order_field?
    if params.order_type?
      if params.order_type == "asc"
        query.addAscending(params.order_field)
      else
        query.addDescending(params.order_field)
    else
      query.addDescending(params.order_field)
  else
  query.addDescending("priority")

  query.addDescending("createdAt")

  #3.skip、limit
  query.skip(parseInt(params.skip))
  query.limit(parseInt(params.max))

  whenjs().then ()->
    query.find()
  .then (results)->
    for result in results
      infoModel = new Model_MissingInfo()
      infoModel.initByTableMissingInfo(result)
      resultList.push infoModel
    return resultList

exports.getMissingInfoById = (info_id)->
  Table_MissingInfo.getById(info_id)
  .then (table_info)->
    if not table_info?
      return null
    infoModel = new Model_MissingInfo()
    infoModel.initByTableMissingInfo(table_info)
    return infoModel


#注：如果params.<attribute>为undefinded,将不会更新对应的值
_setDatasToMissingInfo = (info, params)->
  #丢失人信息
  info.set('name', params.name)
  info.set('sex', params.sex)
  info.set('birth', params.birth)
  info.set('nation', params.nation)
  info.set('height', params.height)
  info.set('clothes', params.clothes)
  info.set('feature', params.feature)
  info.set('pictures', params.pictures)

  #丢失时间、地点、描述
  info.set('missing_date', params.missing_date)
  info.set('missing_place_province', params.missing_place_province)
  info.set('missing_place_city', params.missing_place_city)
  info.set('missing_place_area', params.missing_place_area)
  info.set('missing_place_detail', params.missing_place_detail)
  info.set('description', params.description)