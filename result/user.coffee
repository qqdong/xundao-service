exports.getUserInfo = (userModel)->
  if not userModel?
    return null
  result = {}
  result.id = userModel.getId()
  result.mobile = userModel.getMobile()
  result.nickname = userModel.getNickName() || ""
  result.head_img = userModel.getHeadImg() || ""
  result.description = userModel.getDescription() || ""
  return result

