-- -*- coding: utf-8 -*-
-- @Date    : 2018-03-02 00:51
-- @Author  : chan<-666 (kwancr92@gmail.com)
-- @Link    :
-- @Disc    : Rangers Config

local _M = {}

_M.json = nil

function _M.import_cjson()
    _M.json = require 'cjson'
end

if pcall( _M.import_cjson ) ~= true then
    _M.json = require 'dkjson'
end

return _M.json
