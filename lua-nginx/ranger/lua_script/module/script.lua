-- -*- coding: utf-8 -*-
-- @Date    : 2018-03-02 00:51
-- @Author  : chan<-666 (kwancr92@gmail.com)
-- @Link    :
-- @Disc    : Rangers Config

local shell = require "resty.shell"

local _M = {}
local args = {
  socket = "unix:/tmp/shell.sock",
}

function _M.run(script)
  local status, out, err = shell.execute(script, args)
  return out
end
