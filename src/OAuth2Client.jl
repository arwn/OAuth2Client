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
gettoken(c::Client) =
    let d = HTTP.request(:POST, c.host * "/oauth/token", [],
                "grant_type=client_credentials&" *
                "client_id=$(c.id)&" *
                "client_secret=$(c.secret)").body |>
            String |>
            JSON.parse
        Client(
            c.host,
            c.id,
            c.secret,
            d["access_token"])
    end

request(c::Client, method, endpoint::String) =
    HTTP.request(method, c.host * endpoint, 
        ["Authorization" => "Bearer " * c.token]).body |>
    String |>
    JSON.parse

end # module
