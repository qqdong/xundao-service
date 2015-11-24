AV = require('leanengine')
whenjs = require 'when'

Error_code = require('../../lib/error_code.coffee')
Model_User = require('../../model/user/user.coffee')
Table_User = require('../../avos/table/user.coffee')

#根据id获取用户对象
exports.getUserById = (user_id)->
  Table_User.getById(user_id)
  .then (tableUser)->
    if not tableUser?
      return null
    userModel = new Model_User()
    userModel.initByTableUser(tableUser)
    return userModel

#更新用户信息
exports.updateUserById = (user_id, nick_name, description, head_img)->
  userModel = null
  exports.getUserById(user_id)
  .then (_userModel)->
    throw Error_code.userError.uidInvalid unless _userModel?
    userModel = _userModel
    if description?
      userModel.setDescription(description)

    if head_img?
      userModel.setHeadImg(head_img)

    #nickname是否重复
    if nick_name? and userModel.getNickName() != nick_name
      userModel.setNickName(nick_name)
      existNickName(nick_name)
      .then (isExist)->
        throw Error_code.userError.nickNameAlreadyExist unless not isExist
  .then ()->
    console.log userModel
    userModel.save()
  .then ()->
    return userModel


existNickName = (nickName)->
  Table_User.getByNickName(nickName)
  .then (tableUser)->
    return tableUser?
