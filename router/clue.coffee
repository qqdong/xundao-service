whenjs = require 'when'
request = require 'request'

express = require 'express'
router = express.Router()

Controller_ClueInfo = require('../controller/clue/clue-info.coffee')
Controller_ClueComment = require('../controller/clue/clue-comment.coffee')
Controller_ClueForce = require('../controller/clue/clue-force.coffee')

#发布线索信息
router.post '/publish', Controller_ClueInfo.publish
#更新线索信息
router.post '/update', Controller_ClueInfo.update
#获取线索信息列表
router.post '/list', Controller_ClueInfo.list
#获取线索信息详情
router.post '/detail', Controller_ClueInfo.detail

#评论
router.post '/comment/add',Controller_ClueComment.add
router.post '/comment/list',Controller_ClueComment.list

#关注
router.post '/force/add', Controller_ClueForce.add
router.post '/force/cancel', Controller_ClueForce.cancel
router.post '/force/list', Controller_ClueForce.list


module.exports = exports = router