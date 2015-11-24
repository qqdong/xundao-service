#丢失信息

#1.人员描述
#1)丢失人: name,sex,birth(now_age),nation
#height,clothes,feature,pictures
#2)联系人:消息发布者

#2.时间地点描述
#1)时间:missing_date
#2)地点:missing_place_province,missing_place_city,missing_place_area,missing_place_detail
#3)补充描述:description

#3.关联和其它
#1)信息发布者：user_id
#2)状态：info_state(审核中checking，显示中showing，关闭closed)，find_state(找到1，未找到2)
#3)类型：type_id
#4)显示优先级：priority
#5)悬赏：promise_money
#6)来源网站：source_site

MyDate = require('../../util/MyDate.coffee')
whenjs = require("when")
Model_User = require('../user/user.coffee')
Model_MissingType = require('../missing/missing-type.coffee')

class MissingInfo
  constructor: ()->
    @tableMissingInfo = null
    @userModel = null

  initByTableMissingInfo: (tableInfo)->
    @tableMissingInfo = tableInfo

  #get方法#############################################

  getId: ()->
    return  @tableMissingInfo.id

  getName: ()->
    return  @tableMissingInfo.get('name')

  getMissingAge: ()->
    missingDate = @tableMissingInfo.get('missing_date')
    if missingDate?
      return  MyDate.getAge(missingDate)
    else
      return ""

  getSex: ()->
    return  @tableMissingInfo.get('sex')

  getProvince: ()->
    return  @tableMissingInfo.get('missing_place_province')

  getCity: ()->
    return  @tableMissingInfo.get('missing_place_city')

  getArea: ()->
    return  @tableMissingInfo.get('missing_place_area')

  getPlaceDetail: ()->
    return  @tableMissingInfo.get('missing_place_detail')

  getMissingDate: ()->
    return  @tableMissingInfo.get('missing_date')

  getPictures: ()->
    return  @tableMissingInfo.get('pictures')

  asyncGetPublisher: ()->
    info = this
    userModel = @userModel
    whenjs().then ()->
      if not userModel?
        publisher = info.tableMissingInfo.get("ref_publisher")
        publisher.fetch()
        .then (table_user)->
          userModel = new Model_User()
          userModel.initByTableUser(table_user)
          info.setPublisher(userModel)
    .then ()->
      return userModel

  setPublisher: (userModel)->
    @userModel = userModel

  getBirth: ()->
    return  @tableMissingInfo.get('birth')

  getHeight: ()->
    return  @tableMissingInfo.get('height')

  getClothes: ()->
    return  @tableMissingInfo.get('clothes')

  getFeature: ()->
    return  @tableMissingInfo.get('feature')

  getDescription: ()->
    return  @tableMissingInfo.get('description')

  getState: ()->
    return  @tableMissingInfo.get('info_state')

  getFindState: ()->
    return  @tableMissingInfo.get('find_state')

  getInfoTypeName: ()->
    return  Model_MissingType.getNameById(@tableMissingInfo.get('type_id'))

  getInfoTypeId: ()->
    return  @tableMissingInfo.get('type_id')

  getPromiseMoney: ()->
    return  @tableMissingInfo.get('promise_money')


module.exports = MissingInfo