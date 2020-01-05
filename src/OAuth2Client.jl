module OAuth2Client

import HTTP
import JSON
import Dates

mutable struct Client
    host::String
    id::String
    secret::String
    token::Union{Nothing, String}
    cooldown::Dates.Millisecond
    lastcall::Dates.DateTime
end

Client(host::String, id::String,
        secret::String; 
        cooldown::Dates.Millisecond=Dates.Millisecond(0)) =
    Client(host, id, secret, nothing, cooldown, Dates.DateTime(1))

# handles api rate limits
function _delay!(c::Client)
    if c.cooldown == 0 return end
    now = Dates.now()
    diff = now - c.lastcall
    if diff < c.cooldown
        sleep((c.cooldown - diff).periods[1])
    end
    c.lastcall = Dates.now()
end

# Gets a token using the 'Client Credentials' flow
function gettoken(c::Client)
    req = HTTP.request(:POST, c.host * "/oauth/token", [],
        "grant_type=client_credentials&" *
        "client_id=$(c.id)&" *
        "client_secret=$(c.secret)")
    s = String(req.body)
    j = JSON.parse(s)
    return Client(
        c.host,
        c.id,
        c.secret,
        j["access_token"],
        c.cooldown,
        c.lastcall)
end

function request(c::Client, method, endpoint::String)
    _delay!(c)
    req = HTTP.request(method, c.host * endpoint, 
        ["Authorization" => "Bearer " * c.token])
    s = String(req.body)
    return JSON.parse(s)
end

end # module
