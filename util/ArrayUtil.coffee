class ArrayUtil
  constructor: ->

  @contains: (array, value)->
    for _value in array
      if _value == value
        return true
    return false

module.exports = ArrayUtil