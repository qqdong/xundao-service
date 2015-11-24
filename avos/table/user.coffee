AV = require('leanengine')
whenjs = require 'when'

#根据用户id获取用户对象
exports.getById = (user_id)->
  whenjs().then ()->
    query = new AV.Query(AV.User)
    query.get(user_id)
  .then (user)->
    if not user?
      return null
    return user
  .catch (error)->
    return null

exports.getByNickName = (nick_name)->
  whenjs().then ()->
    query = new AV.Query(AV.User)
    query.equalTo("nick_name", nick_name)
    query.find()
  .then (array)->
    if array.length > 0
      return array[0]
    return null