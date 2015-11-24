var express = require('express');
var fs = require('fs');
var path = require('path');
var morgan = require('morgan');
var mkdirp = require('mkdirp');
var moment = require('moment');

var config = require('../config');

var errorCode = require("../lib/error_code");

morgan.token('apiKey', function (req) {
    return req.body && req.body.apiKey;
});

morgan.token('apiReqData', function (req) {
    return JSON.stringify(req.body);
});

morgan.token('remoteIp', function (req) {
    return req.get('remoteip')
        || req.ip
        || req._remoteAddress
        || (req.connection && req.connection.remoteAddress)
        || undefined;
});


morgan.token('localDate', function () {
    return moment().format();
});


//日志记录
exports.logger = function () {
    var logFormat = ':remoteIp - :apiKey [:localDate] ":method :url" :status :res[content-length] :response-time ":referrer" ":user-agent" :apiReqData';
    return morgan(logFormat, {
        skip: function (req, res) {
            return res.statusCode < 400
        }
    });
};

//全局异常捕获
exports.error = function (err, req, res, next) {
    if (typeof err !== 'string' && !err.error_code && !err.code) {

        if (err.stack) {
            console.log(err.stack)
        } else {
            console.log(err)
        }
    }

    if (typeof err == 'string') {
        res.json({
            error_code: 400,
            error: err
        });
    } else if (err.error_code) {
        res.json(err);
    } else if (err.code) { //avos的错误信息
        res.json({
            error_code: err.code,
            error: err.message
        });
    } else {
        res.json(errorCode.commonError.internalError);
    }
};

//页面不存在
exports.notFound = function (req, res, next) {
    res.status(404).json(errorCode.commonError.notFond)
};


//允许跨域
exports.allowCrossDomain = function (req, res, next) {
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Headers", "X-Requested-With, Content-Type, Auth-Api-Key, Auth-Uid, Auth-Token");
    res.setHeader("Access-Control-Allow-Methods", "GET, POST");
    if (req.method === 'OPTIONS') {
        return res.sendStatus(200);
    }
    next();
};


exports.static = function (dir) {
    return express.static(path.join(__dirname, '../', dir), {
        maxAge: 1000 * 3600 * 24 * 30
    });
};
