Result_user = require('./user.coffee')

exports.getInfoList = (infoModelList)->
  resultList = []
  if not infoModelList?
    return resultList
  for infoModel in infoModelList
    result = {}
    result.id=infoModel.getId()
    result.sex = infoModel.getSex()
    result.age = infoModel.getBeginAge() + "-" + infoModel.getEndAge()
    result.pictures = infoModel.getPictures() || ""
    result.see_date = infoModel.getSeeDate() || ""
    result.see_place_province = infoModel.getProvince() || ""
    result.see_place_city = infoModel.getCity() || ""
    result.see_place_area = infoModel.getArea() || ""
    result.see_place_detail = infoModel.getPlaceDetail() || ""
    resultList.push result
  return resultList

exports.asyncGetInfoDetail = (infoModel)->
  result = {}
  if not infoModel?
    return result
  result.id=infoModel.getId()
  result.sex = infoModel.getSex()
  result.age = infoModel.getBeginAge() + "-" + infoModel.getEndAge()
  result.description = infoModel.getDescription() || ""
  result.pictures = infoModel.getPictures() || ""
  result.see_date = infoModel.getSeeDate() || ""
  result.missing_place_province = infoModel.getProvince() || ""
  result.missing_place_city = infoModel.getCity() || ""
  result.missing_place_area = infoModel.getArea() || ""
  result.missing_place_detail = infoModel.getPlaceDetail() || ""
  result.height = infoModel.getHeight() || ""
  result.clothes = infoModel.getClothes() || ""
  result.feature = infoModel.getFeature() || ""
  infoModel.asyncGetPublisher()
  .then (userModel)->
    result.publisher = Result_user.getUserInfo(userModel)
  .then ()->
    return result
