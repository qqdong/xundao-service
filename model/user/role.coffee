#角色
exports.Role =
  NoCheck: 0
  UnRegister: 1
  Register: 2
  Admin: 3

#将数据库中的角色转换为领域橘色
exports.parseFromTableToModel = (roleId)->
  if not roleId?
    return 2

  switch roleId
    when 1 then 2
    when 2 then 3
    else 1

