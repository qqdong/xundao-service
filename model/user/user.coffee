Device = require('../../util/Device.coffee')
MyTime = require('../../util/MyTime.coffee')
Role = require('./role.coffee')
{UserState}=require('./user-state.coffee')

#领域对象，封装table的属性和操作，外部调用不需要关注table的属性、关系，调用对应方法即可
#1.创建时，一般使用table对象初始化
#2.get一般通过table对象获取值，set一般用来设置table的值

class User

  constructor: ()->
    @tableUser = null

  initByTableUser: (tableUser)->
    @tableUser = tableUser

  save: ()->
    @tableUser.save()

  #是否被拉黑
  isPullBlack: ()->
    if not @getState()?
      return false
    return @getState() == UserState.PullBlack

  #get方法#############################################

  getId: ()->
    return  @tableUser.id

  getMobile: ()->
    return  @tableUser.get('mobilePhoneNumber')

  getRoleId: ()->
    roleId = @tableUser.get('role_id')
    Role.parseFromTableToModel(roleId)

  getState: ()->
    state = @tableUser.get('state')
    if not state?
      return UserState.Normal
    return state

  getTokenTime: (userAgent)->
    tokenTime = 0
    if Device.isNative(userAgent)
      tokenTime = @tableUser.get('token_time')
    else
      tokenTime = @tableUser.get('pc_token_time')
    return tokenTime

  getNickName: ()->
    return @tableUser.get('nick_name')

  getHeadImg: ()->
    return @tableUser.get('head_img')

  getDescription: ()->
    return @tableUser.get('description')

  getCreatedAt: ()->
    return @tableUser.get("createdAt")

  getUpdatedAt: ()->
    return @tableUser.get("updatedAt")

  #set方法#############################################

  setNickName: (nick_name)->
    @tableUser.set("nick_name", nick_name)

  setDescription: (description)->
    @tableUser.set("description", description)

  setHeadImg: (head_img)->
    @tableUser.set("head_img", head_img)

  setState: (state)->
    return @tableUser.set('state', state)

  setTokenTime: (userAgent)->
    if Device.isNative(userAgent)
      @tableUser.set('token_time', MyTime.getCurrentMicroSecond())
    else
      @tableUser.set('pc_token_time', MyTime.getCurrentMicroSecond())


module.exports = User