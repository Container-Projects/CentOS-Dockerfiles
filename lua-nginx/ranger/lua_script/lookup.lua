-- -*- coding: utf-8 -*-
-- @Date    : 2018-03-02 00:51
-- @Author  : chan<-666 (kwancr92@gmail.com)
-- @Link    :
-- @Disc    : Rangers Config

local resolver = require "resty.dns.resolver"

-- local _M = {}
local ali_dns = {"223.5.5.5", {"223.6.6.6", 53} }
local dns_189 = {}
local dns_10010 = {}

local r, err = resolver:new{
    nameservers = ali_dns,
    retrans = 5,
    timeout = 2000,
}
if not r then
  ngx.say("failed to instantiate the resolver: ", err)
  return
end
local answers, err, tries = r:query("kyfw.12306.cn", nil, {})
if not answers then
  ngx.say("failed to query the DNS server: ", err)
  ngx.say("retry historie:\n  ", table.concat(tries, "\n  "))
  return
end

if answers.errcode then
    ngx.say("server returned error code: ", answers.errcode, ": ", answers.errstr)
end

for i, ans in ipairs(answers) do
    ngx.say(ans.name, " ", ans.address or ans.cname," type:", ans.type, " class:", ans.class," ttl:", ans.ttl)
end

-- return _M
