AV = require('leanengine')
whenjs = require 'when'

Error_code = require('../../lib/error_code.coffee')
MyDate = require('../../util/MyDate.coffee')

{CommentType} = require('../../model/comment/comment-type.coffee')
Model_Comment = require('../../model/comment/comment.coffee')

Table_Comment = require('../../avos/table/comment.coffee')
Table_User = require('../../avos/table/user.coffee')

#添加评论
exports.addComment = (type_id, target_id, content, from_user_id, to_user_id)->
  comment = new Table_Comment.Comment()
  fromUser = null
  toUser = undefined
  targetObj = undefined

  #设置fromUser和toUser
  whenjs().then ()->
    Table_User.getById(from_user_id)
  .then (_fromUser)->
    fromUser = _fromUser
    if to_user_id?
      Table_User.getById(to_user_id)
      .then (_toUser)->
        if _toUser?
          toUser = _toUser
  .then ()->
    comment.set('ref_from_user', fromUser) #关联
    comment.set('ref_to_user', toUser) #关联
    #comment.set('ref_target', targetObj)
    comment.set('target_id', target_id)
    comment.set('from_user_id', from_user_id)
    comment.set('to_user_id', to_user_id)
    comment.set('type_id', type_id)
    comment.set('content', content)
    comment.save()
  .then (table_comment)->
    commentModel = new Model_Comment()
    commentModel.initByTableComment(table_comment)
    return commentModel


#获取评论列表
exports.listComment = (type_id, target_id, skip, max)->
  resultList = []
  query = new AV.Query(Table_Comment.Comment);

  #1.查询条件
  query.equalTo('type_id', type_id)
  query.equalTo('target_id', target_id)

  #2.排序
  query.descending("createdAt")

  #3.skip、limit
  query.skip(parseInt(skip))
  query.limit(parseInt(max))

  whenjs().then ()->
    query.find()
  .then (results)->
    for result in results
      commentModel = new Model_Comment()
      commentModel.initByTableComment(result)
      resultList.push commentModel
    return resultList
