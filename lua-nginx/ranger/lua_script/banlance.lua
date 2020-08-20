-- -*- coding: utf-8 -*-
-- @Date    : 2018-03-02 00:51
-- @Author  : chan<-666 (kwancr92@gmail.com)
-- @Link    :
-- @Disc    : Rangers Config

local _M = {}

local balancer = require "ngx.balancer"

function _M.run()
    --ngx.log( ngx.ERR, ngx.var.vn_proxy_target)
    local ok, err = balancer.set_current_peer( ngx.var.vn_proxy_host , ngx.var.vn_proxy_port )
    if not ok then
        ngx.log(ngx.ERR, "failed to set the current peer: ", err)
        return ngx.exit(500)
    end

    return
end

_M.run()

return _M
