# apigateway-examples
Configuration examples with the API Gateway.

Examples in this repository are based on a docker-compose setup with:
* The API Gateway
* Redis 
* [Hello-world](https://github.com/adobe-apiplatform/echo-service) sample microservice
 
These examples assume port `80` is available for the API Gateway.

## Repo structure
* `common` folder defines environment specific info such as redis IP.
* `oauth2/<provide>` folder defines sample configuration files with identity providers   

## OAuth2

Sample configurations for setting up OAuth validation with the following identity providers.

### Google

```bash
> make google
```

Once docker-compose is started open [http://localhost/api/echo/headers/?user_token=123](http://localhost/api/echo/headers/?user_token=123).

You should a message saying that the token is not valid:
```javascript
{
  error_code: "401013",
  message: "Oauth token is not valid"
}
```

To obtain a valid token you can use the [OAuth playground](https://developers.google.com/oauthplayground), authorizing an application against any Google API using the following 2 scopes:
* `https://www.googleapis.com/auth/plus.me`
* `https://www.googleapis.com/auth/userinfo.email`

Copy the `access_token` obtained from the OAuth playground in the URI
`http://localhost/api/echo/headers/?user_token=<access_token>`

Now you should see the request headers printed out:
```
Accept=[text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8]
Accept-Encoding=[gzip, deflate, sdch, br]
Accept-Language=[en-US,en;q=0.8,ro;q=0.6]
Cache-Control=[max-age=0]
Connection=[close]
Cookie=[Idea-164c50e1=c7b8d1e8-8dda-449f-aae0-69e05b2a7097]
Host=[microservice]
Upgrade-Insecure-Requests=[1]
User-Agent=[Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36]
X-GW-Client-Id=[XXXXXXXX.apps.googleusercontent.com]
X-GW-Scope=[https://www.googleapis.com/auth/plus.me https://www.googleapis.com/auth/userinfo.email]
X-GW-User-Id=[XXXXXXXXXX]
```

The `X-GW-*` headers have been added by the Gateway from the information associated with the OAuth token. 

###### View what has been saved in Redis Cache

```bash
> docker-compose exec redis redis-cli KEYS cachedoauth:*
1) "cachedoauth:XXXXXXXXXXXXXX:www.googleapis.com"

# view the info cached for this token
> docker-compose exec redis redis-cli HGET cachedoauth:XXXXXXXXXXXXXX:www.googleapis.com token_json

# verify the TTL for the cached info in Redis
> docker-compose exec redis redis-cli TTL cachedoauth:XXXXXXXXXXXXXX:www.googleapis.com
(integer) <seconds>
```

### Facebook 
Comming soon

### Twitter
Comming soon
