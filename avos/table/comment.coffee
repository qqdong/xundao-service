AV = require('leanengine')
whenjs = require 'when'

Comment = exports.Comment = AV.Object.extend("comment")

#根据id获取对象
exports.getById = (id)->
  whenjs().then ()->
    query = new AV.Query(Comment)
    query.get(id)
  .then (comment)->
    if not comment?
      return null
    return comment
  .catch (error)->
    return null