express = require("express")
bodyParser = require("body-parser")
cookieParser = require("cookie-parser")

middleware = require("../lib/middleware")


router = express.Router()

#记录request请求信息
router.use middleware.logger()
#允许跨域
router.use middleware.allowCrossDomain

router.get '/headers', (req, res) -> res.json req.headers

#处理表单编码为application/x-www-form-urlencoded的请求
router.use bodyParser.urlencoded
  extended: false

#将请求body中的json字符串解析成json对象，赋值给req.body
router.use bodyParser.json()

#路由配置
router.use '/user', require('./user.coffee')
router.use '/missing', require('./missing.coffee')
router.use '/clue', require('./clue.coffee')

#api不存在和全局错误处理
router.use middleware.notFound
router.use middleware.error

module.exports = exports = router
