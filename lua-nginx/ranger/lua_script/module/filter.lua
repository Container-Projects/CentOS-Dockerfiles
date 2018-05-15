-- -*- coding: utf-8 -*-
-- @Date    : 2018-03-02 00:51
-- @Author  : chan<-666 (kwancr92@gmail.com)
-- @Link    :
-- @Disc    : Rangers Config

local _M = {}

local rangerConfig = require "rangerConfig"
local request_tester = require "request_tester"


function _M.filter()

    if rangerConfig.configs["filter_enable"] ~= true then
        return
    end

    local matcher_list = rangerConfig.configs['matcher']
    local response_list = rangerConfig.configs['response']
    local response = nil

    for i,rule in ipairs( rangerConfig.configs["filter_rule"] ) do
        local enable = rule['enable']
        local matcher = matcher_list[ rule['matcher'] ]
        if enable == true and request_tester.test( matcher ) == true then
            local action = rule['action']
            if action == 'accept' then
                return
            else
                if rule['response'] ~= nil then
                    ngx.status = tonumber( rule['code'] )
                    response = response_list[rule['response']]
                    if response ~= nil then
                        ngx.header.content_type = response['content_type']
                        ngx.say( response['body'] )
                        ngx.exit( ngx.HTTP_OK )
                    end
                else
                    ngx.exit( tonumber( rule['code'] ) )
                end
            end
        end
    end
end

return _M
