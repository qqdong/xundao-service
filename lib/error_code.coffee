#约定如下：

#1.公共错误码
#400 参数缺失或错误
#401 权限不允许
#404 页面未找到
#500 服务器内部错误

#2.业务错误码
#10000-10999 用户
#20000-20999 作品

#后续依次扩展，第一位超过9时，接着是11000，12000......12999,13000......99999


#==================================#
class error
  constructor: (@error_code, @error) ->


exports.commonError =
  parameterError: new error 400, '参数错误'
  noPermissions: new error 401, '没有权限操作'
  ipIsBlocked: new error 402, '此ip不能访问'
  notFond: new error 404, '请求资源不存在'
  apiKeyNotFound: new error 405, "缺少apiKey"
  internalError: new error 500, '服务器内部错误'
  catalogCacheUpdateFailedError: new error 601, '分类缓存更新失败'

exports.userError =
  requireLogin: new error 10001, '请先登录'
  uidInvalid: new error 10002, 'uid无效'
  nickNameAlreadyExist: new error 10003, '昵称已存在'
  pulledBlack: new error 10004, '被拉黑'

exports.missingError =
  missingIdInvalid: new error 20001, '丢失信息id无效'

exports.clueError =
  clueIdInvalid: new error 30001, '线索信息id无效'


#设置为不可修改
Object.freeze exports.commonError

