whenjs = require('when')

Result_user = require('./user.coffee')


exports.asyncGetCommentList = (commentModelList)->
  resultList = []
  if not commentModelList?
    return resultList

  whenjs.map commentModelList, (commentModel, index)->
    result = {}
    result.id = commentModel.getId()
    result.content = commentModel.getContent()
    result.add_date = commentModel.getCreatedDate()
    commentModel.asyncGetFromUser()
    .then (fromUser)->
      result.from_user = Result_user.getUserInfo(fromUser)
      commentModel.asyncGetToUser()
    .then (toUser)->
      result.to_user = Result_user.getUserInfo(toUser) || null
      resultList[index] = result
  .then ()->
    return resultList