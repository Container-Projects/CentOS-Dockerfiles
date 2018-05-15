-- -*- coding: utf-8 -*-
-- @Date    : 2018-03-02 00:51
-- @Author  : chan<-666 (kwancr92@gmail.com)
-- @Link    :
-- @Disc    : Rangers Config

local rangerConfig = require "rangerConfig"
local dkjson = require "dkjson"


local _M = {}
_M.seed = nil

function _M.get_seed()

    --return seed from memory
    if _M.seed ~= nil then
        return _M.seed
    end

    --return saved seed
    local seed_path = rangerConfig.home_path() .. "/configs/encrypt_seed.json"

    local file = io.open( seed_path, "r")
    if file ~= nil then
        local data = file:read("*all");
        file:close();
        local tmp = dkjson.decode( data )

        _M.seed = tmp['encrypt_seed']

        return _M.seed
    end


    --if no saved seed, generate a new seed and saved
    _M.seed = ngx.md5( ngx.now() )
    local new_seed_json = dkjson.encode( { ["encrypt_seed"]= _M.seed }, {indent=true} )
    local file,err = io.open( seed_path, "w")

    if file ~= nil then
        file:write( new_seed_json )
        file:close()
        return _M.seed
    else
        ngx.log(ngx.STDERR, 'save encrypt_seed failed' )
        return ''
    end

end

function _M.generate()
end

return _M
