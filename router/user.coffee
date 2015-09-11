whenjs = require 'when'
request = require 'request'
nodefn = require 'when/node'

express = require 'express'
router = express.Router()

Controller_user=require('../controller/user.coffee')

router.post '/registerWithMobile',Controller_user.registerWithMobile

module.exports=exports=router