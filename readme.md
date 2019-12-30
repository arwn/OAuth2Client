# OAuth2Client
client_credentials works

## example program
```julia
client = OAuth2Client.Client("https://api.intra.42.fr",
    "user_id", "user_secret", nothing) |> OAuth2Client.gettoken

response = OAuth2Client.request(client, :GET, "/oauth/token/info")

println(response)
```

## todo
- implement other workflows: Authorization Code, Implicit, 
    Resource Owner Password Credentials
- fix bugs
