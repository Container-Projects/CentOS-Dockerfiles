-- -*- coding: utf-8 -*-
-- @Date    : 2018-03-02 00:51
-- @Author  : chan<-666 (kwancr92@gmail.com)
-- @Link    :
-- @Disc    : Rangers Config

local _M = {}

--The md5 of config string
_M.config_hash = nil

_M["configs"] = {}

--------------default config------------

_M.configs["config_version"] = "0.36"
_M.configs["readonly"] = false
_M.configs["base_uri"] = "/ranger"
_M.configs['dashboard_host'] = ""
_M.configs['cookie_prefix'] = "ranger"
_M.configs["admin"] = {
    { ["user"] = "sergeant", ["password"] = "chan<-666", ["enable"] = true}
}

_M.configs['matcher'] = {
    ["all_request"] = {},
    ["attack_sql_0"] = {
        ["Args"] = {
            ['name_operator'] = "*",
            ['operator'] = "≈",
            ['value']="select.*from",
        },
    },
    ["attack_backup_0"] = {
        ["URI"] = {
            ['operator'] = "≈",
            ['value']="\\.(htaccess|bash_history|ssh|sql)$",
        },
    },
    ["attack_scan_0"] = {
        ["UserAgent"] = {
            ['operator'] = "≈",
            ['value']="(nmap|w3af|netsparker|nikto|fimap|wget)",
        },
    },
    ["attack_code_0"] = {
        ["URI"] = {
            ['operator'] = "≈",
            ['value']="\\.(git|svn|\\.)",
        },
    },
    ["ip"] = {
        ["IP"] = {
            ["operator"] = "!≈",
            ["value"] = "(127.0.0.1|198.0.0.1)",
        }
    },
    ["dial"] = {
        ["URI"] = {
            ['operator'] = "=",
            ['value']="/dial",
        }
    },
    ["root"] = {
        ["URI"] = {
            ['operator'] = "=",
            ['value'] = "/"
        }
    },
}

_M.configs["response"] = {
    ["demo_response_html"] = {
        ["content_type"] = "text/html",
        ["body"] = "This is a html demo response",
    },
    ["demo_response_json"] = {
        ["content_type"] = "application/json",
        ["body"] = '{"msg":"soms text","status":"success"}',
    },
    ["warning_json"] = {
        ["content_type"] = "application/json",
        ["body"] = '{"msg":"get off the way"}',
    },
    ["frequency_limit_json"] = {
        ["content_type"] = "application.json",
        ["body"] = '{"msg":"request too many"}',
    }
}

_M.configs["backend_upstream"] = {
}

_M.configs["summary_collect_rule"] = {
}

_M.configs["scheme_lock_enable"] = false
_M.configs["scheme_lock_rule"] = {
    {["matcher"] = 'ranger', ["scheme"] = "https", ["enable"] = false},
}

_M.configs["redirect_enable"] = false
_M.configs["redirect_rule"] = {
    --redirect to a static uri
    {["matcher"] = 'ranger', ["to_uri"] = "/ranger/index.html", ["enable"] = true},
}

_M.configs["uri_rewrite_enable"] = false
_M.configs["uri_rewrite_rule"] = {
    --redirect to a Regex generate uri
    {["matcher"] = 'ranger', ["replace_re"] = "^/vn/(.*)", ["to_uri"] = "/ranger/$1", ["enable"] = true},
}

_M.configs["browser_verify_enable"] = false
_M.configs["browser_verify_rule"] = {
}

_M.configs["filter_enable"] = true
_M.configs["filter_rule"] = {
    {["matcher"] = 'ip', ["action"] = "block", ["enable"] = true , ["code"] = '403' , ["response"] = "warning_json"},
    {["matcher"] = 'attack_sql_0', ["action"] = "block", ["code"] = '403', ["enable"] = true , ["response"] = "warning_json"},
    {["matcher"] = 'attack_backup_0', ["action"] = "block", ["code"] = '403', ["enable"] = true , ["response"] = "warning_json"},
    {["matcher"] = 'attack_scan_0', ["action"] = "block", ["code"] = '403', ["enable"] = true , ["response"] = "warning_json"},
    {["matcher"] = 'attack_code_0', ["action"] = "block", ["code"] = '403', ["enable"] = true , ["response"] = "warning_json"},
}

_M.configs["proxy_pass_enable"] = true
_M.configs["proxy_pass_rule"] = {
}

_M.configs["forward_pass_enble"] = true
_M.configs["forward_pass_rule"] = {
    {["matcher"] = 'dial', ["enable"] = true , ["type"] = 'script' , ["command"] = 'uname -a'},
    {["matcher"] = 'root', ["enable"] = true , ["type"] = 'proxy'},
}

_M.configs["static_file_enable"] = true
_M.configs["static_file_rule"] = {}

_M.configs["frequency_limit_enable"] = true
_M.configs["frequency_limit_rule"] = {
  {["enable"] = true , ["matcher"] = 'dial' , ["separate"] = {"uri"} , ["time"] = '10', ["count"] = '1' , ["code"] = '429' , ["response"] = 'frequency_limit_json'},
}

_M.configs["summary_request_enable"] = true
_M.configs["summary_with_host"] = false
_M.configs["summary_group_persistent_enable"] = true
_M.configs["summary_group_temporary_enable"] = true
_M.configs["summary_temporary_period"] = 60
----------------------Config End-------------
local dkjson = require "dkjson"
local json = require "json"


function _M.home_path()
    local current_script_path = debug.getinfo(1, "S").source:sub(2)
    local home_path = current_script_path:sub( 1, 0 - string.len("/lua_script/rangerConfig.lua") -1 )
    return home_path
end

function _M.update_config()
    --save a hash of current in lua environment
    local new_config_hash = ngx.shared.status:get('vn_config_hash')
    if new_config_hash ~= nil and new_config_hash ~= _M.config_hash then
        ngx.log(ngx.STDERR,"config Hash Changed:now reload config from config.json")
        _M.load_from_file()
    end
end


function _M.load_from_file()
    local config_dump_path = _M.home_path() .. "/configs/config.json"
    local file = io.open( config_dump_path, "r")

    if file == nil then
        return json.encode({["ret"]="error",["msg"]="config file not found"})
    end

    --file = io.open( "/tmp/config.json", "w");
    local data = file:read("*all");
    file:close();

    local config_hash = ngx.md5(data)
    _M.config_hash = config_hash
    ngx.shared.status:set('vn_config_hash', config_hash )

    --ngx.log(ngx.STDERR, data)
    local tmp = dkjson.decode( data )
    if tmp ~= nil then
        --update config version if need
        local loop = true
        while loop do
            local handle = _M.version_updater[ tmp['config_version'] ]
            if handle ~= nil then
                tmp = handle( tmp )
            else
                loop = false
            end
        end

        if tmp['config_version'] ~= _M["configs"]["config_version"] then
            ngx.log(ngx.STDERR,"load config from config.json error,will use default config")
            ngx.log(ngx.STDERR,"Except Version:")
            ngx.log(ngx.STDERR, _M["configs"]["config_version"] )
            ngx.log(ngx.STDERR,"Config.json Version:")
            ngx.log(ngx.STDERR,tmp["config_version"])
        else
            _M["configs"] =  tmp
        end

        return json.encode({["ret"]="success",['config']=_M["configs"]})
    else
        ngx.log(ngx.STDERR,"config.json decode error")
        return json.encode({["ret"]="error",["msg"]="config file decode error, will use default"})
    end

end

--return a json contain current config items
function _M.report()
    _M.set_config_metadata( _M["configs"] )
    return dkjson.encode( _M["configs"] )
end

function _M.verify()
    return true
end

function _M.set()
    local ret = false
    local err = nil
    local args = nil
    local dump_ret = nil

    ngx.req.read_body()
    args, err = ngx.req.get_post_args()
    if not args then
        ngx.say("failed to get post args: ", err)
        return
    end

    local new_config_json_escaped_base64 = args['config']
    local new_config_json_escaped = ngx.decode_base64( new_config_json_escaped_base64 )
    --ngx.log(ngx.STDERR,new_config_json_escaped)

    local new_config_json = ngx.unescape_uri( new_config_json_escaped )
    --ngx.log(ngx.STDERR,new_config_json)

    local new_config = json.decode( new_config_json )

    if _M.configs['readonly'] == true then
        ret = false
        err = "all configs was set to readonly"
    elseif _M.verify( new_config ) == true then
        ret, err = _M.dump_to_file( new_config )
    end

    if ret == true then
        return json.encode({["ret"]="success",["err"]=err})
    else
        return json.encode({["ret"]="failed",["err"]=err})
    end
end

function _M.set_config_metadata( config_table )

    --make sure empty table trans to right type
    local meta_table = {}
    meta_table['__jsontype'] = 'object'

    if config_table['matcher'] ~= nil then
        setmetatable( config_table['matcher'], meta_table )
        for key, t in pairs( config_table["matcher"] ) do
            setmetatable( t, meta_table )
        end
    end

    if config_table['backend_upstream'] ~= nil then
        setmetatable( config_table['backend_upstream'], meta_table )
        for key, t in pairs( config_table["backend_upstream"] ) do
            setmetatable( t['node'], meta_table )
        end
    end

    if config_table['response'] ~= nil then
        setmetatable( config_table['response'], meta_table )
    end
    --set table meta_data end

end

function _M.dump_to_file( config_table )

    _M.set_config_metadata( config_table )

    local config_data = dkjson.encode( config_table , {indent=true} ) --must use dkjson at here because it can handle the metadata
    local config_dump_path = _M.home_path() .. "/configs/config.json"

    --ngx.log(ngx.STDERR,config_dump_path)
    local file, err = io.open( config_dump_path, "w")
    if file ~= nil then
        file:write(config_data)
        file:close()
        --update config hash in shared dict
        ngx.shared.status:set('vn_config_hash', ngx.md5(config_data) )
        return true
    else
        return false, "open file failed"
    end

end

--auto load config from json file
_M.load_from_file()

return _M
