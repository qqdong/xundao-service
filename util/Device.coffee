class Device
  constructor: ->

  @isNative : (userAgent)->
    if Device.isAndroid(userAgent) or Device.isIPhone(userAgent)
      return true
    else
      return false

  @isIPhone : (userAgent)->
    iPhone = /.*iPhone.*ios/i
    return iPhone.test(userAgent)

  @isAndroid : (userAgent)->
    android = /.*Android.*Mobile/i
    return android.test(userAgent)

module.exports = Device

