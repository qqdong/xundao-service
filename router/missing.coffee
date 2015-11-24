whenjs = require 'when'
request = require 'request'

express = require 'express'
router = express.Router()

Controller_MissingInfo = require('../controller/missing/missing-info.coffee')
Controller_MissingComment = require('../controller/missing/missing-comment.coffee')
Controller_MissingForce = require('../controller/missing/missing-force.coffee')

#发布丢失信息
router.post '/publish', Controller_MissingInfo.publish
#更新丢失信息
router.post '/update', Controller_MissingInfo.update
#获取丢失信息列表
router.post '/list', Controller_MissingInfo.list
#获取丢失信息详情
router.post '/detail', Controller_MissingInfo.detail

#评论
router.post '/comment/add', Controller_MissingComment.add
router.post '/comment/list', Controller_MissingComment.list

#关注
router.post '/force/add', Controller_MissingForce.add
router.post '/force/cancel', Controller_MissingForce.cancel
router.post '/force/list', Controller_MissingForce.list


module.exports = exports = router