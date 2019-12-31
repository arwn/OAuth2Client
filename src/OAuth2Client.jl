module OAuth2Client

import HTTP
import JSON

struct Client
    host::String
    id::String
    secret::String
    token::Union{Nothing, String}
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
        j["access_token"])
end

function request(c::Client, method, endpoint::String)
    req = HTTP.request(method, c.host * endpoint, 
        ["Authorization" => "Bearer " * c.token])
    s = String(req.body)
    return JSON.parse(s)
end

end # module
