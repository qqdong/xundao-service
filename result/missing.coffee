Result_user = require('./user.coffee')

exports.getInfoList = (infoModelList)->
  resultList = []
  if not infoModelList?
    return resultList
  for infoModel in infoModelList
    result = {}
    result.id=infoModel.getId()
    result.name = infoModel.getName()
    result.sex = infoModel.getSex()
    result.missing_age = infoModel.getMissingAge()
    result.pictures = infoModel.getPictures()
    result.missing_date = infoModel.getMissingDate()
    result.missing_place_province = infoModel.getProvince()
    result.missing_place_city = infoModel.getCity()
    result.missing_place_area = infoModel.getArea()
    result.missing_place_detail = infoModel.getPlaceDetail()
    resultList.push result
  return resultList

exports.asyncGetInfoDetail = (infoModel)->
  result = {}
  if not infoModel?
    return result
  result.id=infoModel.getId()
  result.name = infoModel.getName()
  result.sex = infoModel.getSex()
  result.missing_age = infoModel.getMissingAge()
  result.birth = infoModel.getBirth()
  result.height = infoModel.getHeight()
  result.clothes = infoModel.getClothes()
  result.feature = infoModel.getFeature()
  result.description = infoModel.getDescription()
  result.pictures = infoModel.getPictures()
  result.missing_date = infoModel.getMissingDate()
  result.missing_place_province = infoModel.getProvince()
  result.missing_place_city = infoModel.getCity()
  result.missing_place_area = infoModel.getArea()
  result.missing_place_detail = infoModel.getPlaceDetail()
  result.type_name = infoModel.getInfoTypeName()
  result.promise_money = infoModel.getPromiseMoney()

  infoModel.asyncGetPublisher()
  .then (userModel)->
    result.publisher = Result_user.getUserInfo(userModel)
  .then ()->
    return result
