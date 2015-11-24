#评论,丢失信息评论、线索信息评论
#id,target_id,type_id,content,ref_from_user,ref_to_user
whenjs=require('when')

MyTime = require('../../util/MyTime.coffee')

Model_User = require('../user/user.coffee')
{CommentType}=require('./comment-type.coffee')

#领域对象，封装table的属性和操作，外部调用不需要关注table的属性、关系，调用对应方法即可
#1.创建时，一般使用table对象初始化
#2.get一般通过table对象获取值，set一般用来设置table的值

class Comment

  constructor: ()->
    @tableComment = null
    @fromUser = null
    @toUser = null

  initByTableComment: (tableComment)->
    @tableComment = tableComment

  save: ()->
    @tableComment.save()


  #get方法#############################################
  getId: ()->
    return  @tableComment.id

  getContent: ()->
    return  @tableComment.get('content')

  asyncGetFromUser: ()->
    comment = this
    fromUser = @fromUser
    whenjs().then ()->
      if not fromUser?
        _fromUser = comment.tableComment.get("ref_from_user")
        _fromUser.fetch()
        .then (table_user)->
          fromUser = new Model_User()
          fromUser.initByTableUser(table_user)
          comment._setFromUser(fromUser)
    .then ()->
      return fromUser

  asyncGetToUser: ()->
    comment = this
    toUser = @toUser
    whenjs().then ()->
      if not toUser?
        _toUser = comment.tableComment.get("ref_to_user")
        if _toUser?
          _toUser.fetch()
          .then (table_user)->
            toUser = new Model_User()
            toUser.initByTableUser(table_user)
            comment._setToUser(toUser)
    .then ()->
      return toUser

  getCreatedDate: ()->
    return @tableComment.get('createdAt')

  #set方法#############################################
  _setFromUser: (fromUser)->
    @fromUser = fromUser

  _setToUser: (toUser)->
    @toUser = toUser

module.exports = Comment
