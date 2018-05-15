-- -*- coding: utf-8 -*-
-- @Date    : 2018-03-02 00:51
-- @Author  : chan<-666 (kwancr92@gmail.com)
-- @Link    :
-- @Disc    : Rangers Config

local summary = require "summary"
local filter = require "filter"
local browser_verify = require "browser_verify"
local frequency_limit = require "frequency_limit"
local router = require "router"

-- if ngx.var.vn_exec_flag and ngx.var.vn_exec_flag ~= '' then
--     return
-- end

summary.pre_run_matcher()

filter.filter()
browser_verify.filter()
frequency_limit.filter()
-- router.filter()
-- forward_proxy.filter()
-- backend_proxy.filter()
