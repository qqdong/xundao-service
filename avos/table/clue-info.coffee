AV = require('leanengine')
whenjs = require 'when'

ClueInfo = exports.ClueInfo = AV.Object.extend("clue_info")

#根据id获取对象
exports.getById = (info_id)->
  whenjs().then ()->
    query = new AV.Query(ClueInfo)
    query.get(info_id)
  .then (info)->
    if not info?
      return null
    return info
  .catch (error)->
    return null