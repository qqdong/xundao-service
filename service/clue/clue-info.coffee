AV = require('leanengine')
whenjs = require 'when'

Error_code = require('../../lib/error_code.coffee')
Model_ClueInfo = require('../../model/clue/clue-info.coffee')
ClueState = require('../../model/clue/clue-state.coffee')
MyDate = require('../../util/MyDate.coffee')
Table_ClueInfo = require('../../avos/table/clue-info.coffee')
Table_User = require('../../avos/table/user.coffee')
Table_MissingInfo = require('../../avos/table/missing-info.coffee')

#发布线索信息
exports.publishClueInfo = (params)->
  info = new Table_ClueInfo.ClueInfo()

  whenjs().then ()->
    if params.missing_id?  #关联missing_id
      Table_MissingInfo.getById(params.missing_id)
      .then (table_missing)->
        if table_missing?
          info.set('missing_id', params.missing_id)
          info.set('ref_missing', table_missing)
  .then ()->
    Table_User.getById(params.user_id)
  .then (user)->
    _setDatasToClueInfo(info, params)
    info.set('ref_publisher', user) #关联
    info.set('user_id', params.user_id)
    info.set('info_state', ClueState.ClueInfoState.Showing)
    info.save()
  .then (table_info)->
    infoModel = new Model_ClueInfo()
    infoModel.initByTableClueInfo(table_info)
    return infoModel

#更新线索信息
exports.updateClueInfo = (params)->
  whenjs().then ()->
    Table_ClueInfo.getById(params.info_id)
  .then (info)->
    throw Error_code.clueError.clueIdInvalid unless info?
    _setDatasToClueInfo(info, params)
    info.save()
  .then (table_info)->
    infoModel = new Model_ClueInfo()
    infoModel.initByTableClueInfo(table_info)
    return infoModel

#获取线索信息列表
exports.listClueInfo = (params)->
  resultList = []
  query = new AV.Query(Table_ClueInfo.ClueInfo);

  #1.查询条件
  #地区
  if params.see_place_province then  query.equalTo("see_place_province", params.see_place_province)
  if params.see_place_city then query.equalTo("see_place_city", params.see_place_city)
  if params.see_place_area then query.equalTo("see_place_area", params.see_place_area)
  #性别
  if params.sex then query.equalTo("sex", params.sex)
  #丢失时间
  if params.see_begin_date then query.greaterThanOrEqualTo("see_date", params.see_begin_date)
  if params.see_end_date then query.lessThanOrEqualTo("see_date", params.see_end_date)
  #年龄
  if params.begin_age? then query.greaterThanOrEqualTo("begin_age", params.begin_age)
  if params.end_age? then query.lessThanOrEqualTo("end_age", params.end_age)
  #状态,只显示showing
  query.equalTo('info_state', ClueState.ClueInfoState.Showing)

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
      infoModel = new Model_ClueInfo()
      infoModel.initByTableClueInfo(result)
      resultList.push infoModel
    return resultList

exports.getClueInfoById = (info_id)->
  Table_ClueInfo.getById(info_id)
  .then (table_info)->
    if not table_info?
      return null
    infoModel = new Model_ClueInfo()
    infoModel.initByTableClueInfo(table_info)
    return infoModel


#注：如果params.<attribute>为undefinded,将不会更新对应的值
_setDatasToClueInfo = (info, params)->
  #丢失人信息
  info.set('sex', params.sex)
  info.set('begin_age', params.begin_age)
  info.set('end_age', params.end_age)
  info.set('height', params.height)
  info.set('clothes', params.clothes)
  info.set('feature', params.feature)
  info.set('pictures', params.pictures)

  #发现时间、地点、描述
  info.set('see_date', params.see_date)

  info.set('see_place_province', params.see_place_province)
  info.set('see_place_city', params.see_place_city)
  info.set('see_place_area', params.see_place_area)
  info.set('see_place_detail', params.see_place_detail)
  info.set('description', params.description)