#评论,丢失信息评论、线索信息评论
#id,target_id,type_id,content,ref_from_user,ref_to_user
whenjs = require('when')

MyTime = require('../../util/MyTime.coffee')

Model_User = require('../user/user.coffee')
{ForceType}=require('./force-type.coffee')

#领域对象，封装table的属性和操作，外部调用不需要关注table的属性、关系，调用对应方法即可
#1.创建时，一般使用table对象初始化
#2.get一般通过table对象获取值，set一般用来设置table的值

class Force

  constructor: ()->
    @tableForce = null
    @fromUser = null
    @toUser = null

  initByTableForce: (tableForce)->
    @tableForce = tableForce

  save: ()->
    @tableForce.save()


  #get方法#############################################
  getId: ()->
    return  @tableForce.id

  getTypeId: ()->
    return @tableForce.get('type_id')


#set方法#############################################


module.exports = Force
