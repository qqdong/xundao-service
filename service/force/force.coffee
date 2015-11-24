AV = require('leanengine')
whenjs = require 'when'

Error_code = require('../../lib/error_code.coffee')
MyDate = require('../../util/MyDate.coffee')

{ForceType} = require('../../model/force/force-type.coffee')
Model_Force = require('../../model/force/force.coffee')

Table_Force = require('../../avos/table/force.coffee')
Table_User = require('../../avos/table/user.coffee')

#关注
exports.addForce = (type_id, target_id, user_id)->
  force = new Table_Force.Force()
  user = null

  #设置fromUser和toUser
  whenjs().then ()->
    Table_User.getById(user_id)
  .then (_user)->
    user = _user
  .then ()->
    force.set('ref_user', user) #关联
    force.set('target_id', target_id)
    force.set('user_id', user_id)
    force.set('type_id', type_id)
    force.save()
  .then (table_force)->
    forceModel = new Model_Force()
    forceModel.initByTableForce(table_force)
    return forceModel


#取消关注
exports.cancelForce = (type_id, target_id, user_id)->
  query = new AV.Query(Table_Force.Force);

  #1.查询条件
  query.equalTo('type_id', type_id)
  query.equalTo('target_id', target_id)
  query.equalTo('user_id', user_id)

  whenjs().then ()->
    query.first()
  .then (force)->
    if force?
      force.destroy()

#获取关注列表
exports.listTargetIdByUserId = (type_id, user_id, skip, max)->
  resultList = []
  query = new AV.Query(Table_Force.Force);

  #1.查询条件
  query.equalTo('type_id', type_id)
  query.equalTo('user_id', user_id)

  #2.排序
  query.descending("createdAt")

  #3.skip、limit
  query.skip(parseInt(skip))
  query.limit(parseInt(max))

  whenjs().then ()->
    query.find()
  .then (results)->
    idArray = []
    if not results?
      return idArray
    for result in results
      idArray.push result.get('target_id')
    return idArray
