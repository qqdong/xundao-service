crypto = require("crypto")


exports.md5 = (str) ->
  crypto.createHash("md5").update(str, 'utf8').digest "hex"

class Security
  constructor: ->
  @isUserTokenValid : (uid,token,tokenTime)->
    if Security.getEncodeToken(uid, tokenTime) == token
      return true
    else
      console.log "right token:" + Security.getEncodeToken(uid, tokenTime)
      return false

  @_encodeMD5 : (str)->
    return crypto.createHash("md5").update(str, 'utf8').digest "hex"

  @getEncodeToken : (uid,tokenTime)->
    return Security._encodeMD5('U3ZFz+83mmyhpTjc' + uid + tokenTime)


module.exports= Security


