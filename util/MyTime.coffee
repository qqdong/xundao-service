class MyTime
  constructor: ->
  @getCurrentSecond : ()->
    now = new Date().getTime()
    return now/1000

  @getCurrentMicroSecond : ()->
    now = new Date().getTime()
    return now

module.exports= MyTime

