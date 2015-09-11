express = require("express")
bodyParser = require("body-parser")
cookieParser = require("cookie-parser")
path = require("path")


router = express.Router()
module.exports = exports = router

middleware = require("../lib/middleware")

#router.use middleware.logger()
router.use middleware.allowCrossDomain

router.get '/headers', (req, res) -> res.json req.headers

router.use bodyParser.urlencoded
  extended: false

router.use bodyParser.json()

router.use '/user',require('./user.coffee')

router.use middleware.notFound
router.use middleware.error
