class Validator
  constructor: ->

  @comparator: 0.0001
  @isNumberEqual: (a, b) ->
    if Math.abs(a - b) < Validator.comparator
      return true
    else
      return false

  @isGreater: (a, b)->
    if a - b > Validator.comparator
      return true
    else
      return false

  @isNullOrEmpty: (values...)->
    for value in values
      if( (not value?) or value = '' )
        return true
    return false


module.exports = Validator

