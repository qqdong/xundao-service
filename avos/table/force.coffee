AV = require('leanengine')
whenjs = require 'when'

Force = exports.Force = AV.Object.extend("force")

#根据id获取对象
exports.getById = (id)->
  whenjs().then ()->
    query = new AV.Query(Force)
    query.get(id)
  .then (force)->
    if not force?
      return null
    return force
  .catch (error)->
    return null