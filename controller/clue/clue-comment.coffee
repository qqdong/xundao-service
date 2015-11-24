whenjs = require 'when'

Error_code = require('../../lib/error_code.coffee')

Permission = require('../base/permission.coffee')
Check = require('../base/check-params.coffee')
{Role}=require('../../model/user/role.coffee')

Service_Comment = require('../../service/comment/comment.coffee')
{CommentType}=require('../../model/comment/comment-type.coffee')
Result_Comment = require('../../result/comment.coffee')


#发表评论
exports.add = (req, res, next)->
  params = req.body

  Check.checkNull(params, [
    'clue_id', 'content'
  ])

  Permission.asynCheckRole(req, Role.Register)
  .then ()->
    Service_Comment.addComment(CommentType.Clue, params.clue_id, params.content, req.uid, params.to_user_id)
  .done (commentModel)->
    res.json
      comment_id: commentModel.getId()
  , next


#获取评论列表
exports.list = (req, res, next)->
  params = req.body

  skip = parseInt(params.skip) || 0
  max = parseInt(params.max) || 10

  Check.checkNull(params, [
    'clue_id'
  ])

  Permission.asynCheckRole(req, Role.UnRegister)
  .then ()->
    Service_Comment.listComment(CommentType.Clue, params.clue_id, skip, max)
  .then (modelList)->
    Result_Comment.asyncGetCommentList(modelList)
  .done (result)->
    res.json result
  , next