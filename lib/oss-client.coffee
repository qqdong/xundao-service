whenjs = require('when')
fs = require('fs')
AV = require('leanengine')

#avos文件client
exports.upload = (file, dir)->
  whenjs.promise (resolve, reject)->
    fs.readFile file.path, (err, data)->
      if (err)
        reject('上传失败')
      base64Data = data.toString('base64')
      avFile = new AV.File(file.name, {base64: base64Data})
      avFile.save().then (data)->
        resolve(avFile.url("url"))
      , (err)->
        console.log err
        reject err


