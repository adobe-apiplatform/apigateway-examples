---
-- A Proxy for Google OAuth API

local cjson = require "cjson"
local http = require "resty.http"
local httpc = http.new()

local request_options = {
    headers = {
        ["Accept"] = "application/json"
    },
    ssl_verify = false
}
local requets_uri = "https://" .. ngx.var.oauth_host .. "/oauth2/v3/tokeninfo?access_token=" .. tostring(ngx.var.authtoken)

local res, err = httpc:request_uri(requets_uri, request_options)
-- convert response
if not res then
    ngx.log(ngx.WARN, "Could not invoke Google API. Error=", err)
    ngx.print('{ "valid": false }')
    return
end

ngx.log(ngx.DEBUG, "Response form Google:" .. tostring(res.body))

local json_resp = cjson.decode(res.body)
if (json_resp.error_description) then
    ngx.print('{ "valid": false }')
    return
end

-- convert Google's response
-- Read more about the fields at: https://developers.google.com/identity/protocols/OpenIDConnect#obtainuserinfo
local oauth_response = {
    token = {
        scope = json_resp.scope,
        client_id = json_resp.aud,
        user_id = json_resp.email
    },
    valid = true
}
ngx.print(cjson.encode(oauth_response))
return
