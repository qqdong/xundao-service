moment = require('moment')

class MyDate
  constructor: ->
  @getAge: (birthDateStr)->
    return moment().year() - moment(birthDateStr).year()

  @getBirthDateByAge: (age)->
    return moment({y: moment().year() - age}).format("YYYY-MM-DD");


module.exports = MyDate

