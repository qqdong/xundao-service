var express = require('express');
var fs = require('fs');
var path = require('path');
var morgan = require('morgan');
var mkdirp = require('mkdirp');
var moment = require('moment');

var config = require('../config');
var logger = require("../lib/logger")(__filename);
var errorCode = require("../lib/error_code");
var requestIp = require('request-ip');

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


exports.logger = function () {
    var logDir = config.logDir || (path.join(process.cwd(), '/var/logs'));

    if (!fs.existsSync(logDir)) {
        mkdirp.sync(logDir);
    }

    var accessLogfile = fs.createWriteStream(path.join(logDir, 'access.log'), {
        flags: 'a'
    });

    var logFormat = ':remoteIp - :apiKey [:localDate] ":method :url" :status :res[content-length] :response-time ":referrer" ":user-agent" :apiReqData';
    return morgan(logFormat, {
        stream: accessLogfile
    });
};

exports.error = function (err, req, res, next) {
    if (typeof err !== 'string' && !err.error_code) {
        logger.error(err.stack);
    }

    if(typeof err=='string'){
        res.json({
            error_code:400,
            error:err
        });
    }else if(err.error_code){
        res.json(err);
    }else{
        res.json(errorCode.commonError.internalError);
    }
};

exports.notFound = function (req, res, next) {
    res.status(404).json(errorCode.commonError.notFond)
};

exports.blockIp = function (req, res, next) {
    clientIp = requestIp.getClientIp(req);
    if (!clientIp.match(/^10[.]/)) {
        res.json(errorCode.commonError.ipIsBlocked);
    }
};

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
