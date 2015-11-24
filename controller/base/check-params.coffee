Error_code = require('../../lib/error_code.coffee')
Util_Array = require('../../util/ArrayUtil.coffee')

exports.checkNull = (params, includes) ->
  for include in includes
    throw Error_code.commonError.parameterError unless params[include]? and params[include] != ''
