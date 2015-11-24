#线索信息

#1.人员描述
#1)丢失人:name,sex,begin_age,end_age,height,clothes,feature,picture

#2.时间地点描述
#1)时间:see_date
#2)地点:see_place_province,see_place_city,see_place_area,see_place_detail
#3)补充描述:description

#3.关联和其它
#1)对应的missing：missing_id，为1时表示基于丢失信息的线索，为0时表示单独的线索
#2)线索发布者：user_id
#3)状态：info_state(审核中checking，显示中showing，关闭closed)
#4)显示优先级：priority

whenjs = require("when")
Model_User = require('../user/user.coffee')

class ClueInfo
  constructor: ()->
    @tableClueInfo = null

  initByTableClueInfo: (tableInfo)->
    @tableClueInfo = tableInfo

  #get方法#############################################

  getId: ()->
    return  @tableClueInfo.id

  getBeginAge: ()->
    missingDate = @tableClueInfo.get('begin_age')

  getEndAge: ()->
    missingDate = @tableClueInfo.get('end_age')

  getSex: ()->
    return  @tableClueInfo.get('sex')

  getProvince: ()->
    return  @tableClueInfo.get('see_place_province')

  getCity: ()->
    return  @tableClueInfo.get('see_place_city')

  getArea: ()->
    return  @tableClueInfo.get('see_place_area')

  getPlaceDetail: ()->
    return  @tableClueInfo.get('see_place_detail')

  getSeeDate: ()->
    return  @tableClueInfo.get('see_date')

  getPictures: ()->
    return  @tableClueInfo.get('pictures')

  asyncGetPublisher: ()->
    info = this
    userModel = @userModel
    whenjs().then ()->
      if not userModel?
        publisher = info.tableClueInfo.get("ref_publisher")
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
    return  @tableClueInfo.get('birth')

  getHeight: ()->
    return  @tableClueInfo.get('height')

  getClothes: ()->
    return  @tableClueInfo.get('clothes')

  getFeature: ()->
    return  @tableClueInfo.get('feature')

  getDescription: ()->
    return  @tableClueInfo.get('description')

  getState: ()->
    return  @tableClueInfo.get('info_state')


module.exports = ClueInfo