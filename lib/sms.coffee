AV= require('leanengine')
whenjs = require 'when'

Error_code=require('../lib/error_code.coffee')

exports.send=(mobile,template)->
  whenjs().then ()->
    AV.Cloud.requestSmsCode
      mobilePhoneNumber: mobile
      template: template
      name: '寻到了'
      date: ''
      ttl: 30
