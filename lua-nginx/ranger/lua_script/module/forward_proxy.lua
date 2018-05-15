-- -*- coding: utf-8 -*-
-- @Date    : 2018-03-02 00:51
-- @Author  : chan<-666 (kwancr92@gmail.com)
-- @Link    :
-- @Disc    : Rangers Config

local _M = {}

local rangerConfig = require "rangerConfig"
local request_tester = require "request_tester"
local resolver = require "resty.dns.resolver"
local shell = require "resty.shell"
local math = require "math"
local util = require "util"

function _M.filter()
    if rangerConfig.configs["forward_pass_enble"] ~= true then
        return
    end

    local master_matcher = rangerConfig.configs['matcher']

    for i, rule in ipairs( rangerConfig.configs['forward_pass_rule'])
        local enable = rule['enable']
        ngx.log( ngx.ERR , 'enble', enable)
        local matcher = matcher_list[ rule['matcher'] ]
        if enable == true and request_tester.test( matcher ) == true then
          local exec = rule['type']
          ngx.log( ngx.ERR , 'exec', exec)
          if exec == "script" and rule['command'] ~= '' then
            local status, out, err = shell.execute(rule['command'], rule['args'])
            ngx.log( ngx.ERR , 'script', out)
            ngx.var.vn_exec_flag = '1'
            util.ngx_ctx_dump()
            ngx.say( out )
            ngx.exit( ngx.HTTP_OK )
          elseif exec = "proxy" then
            ngx.var.vn_exec_flag = '1'
            util.ngx_ctx_dump()
            ngx.log( ngx.ERR , 'forward_proxy', exec)
            return ngx.exec('@forward_proxy')
          end
          ngx.var.vn_exec_flag = '1'
          util.ngx_ctx_dump()
          return ngx.exit( ngx.HTTP_ERROR )
        end
    end
end

return _M
