#丢失类型
#被拐被骗、离家出走、走散走失、寻家找亲、友情爱情、流浪之家、不明原因
#先写死在代码中

MissingType = exports.MissingType = [
  {
    id: 1
    name: '被拐被骗'
  }, {
    id: 2
    name: '离家出走'
  }, {
    id: 3
    name: '走失走散'
  }, {
    id: 4
    name: '寻家找亲'
  }, {
    id: 5
    name: '友情爱情'
  }, {
    id: 6
    name: '流浪之家'
  }, {
    id: 7
    name: '不明原因'
  }
]

exports.getNameById = (type_id)->
  if not type_id?
    return "未知"
  type_id = parseInt(type_id)
  for typeObj in MissingType
    if typeObj.id == type_id
      return typeObj.name

  return "未知"
