# apigateway-examples
Configuration examples with the API Gateway.

Examples in this repository are based on a docker-compose setup with:
* The API Gateway
* Redis
* [Hello-world](https://github.com/adobe-apiplatform/echo-service) sample microservice

These examples assume port `80` is available for the API Gateway.

## Repo structure
* `common` folder defines environment specific info such as redis IP.
* `oauth2/<provider>` folder defines sample configuration files with identity providers
* `benchmark` folder defines a configuration file to be used for running some benchmarks. More details [bellow](#benchmark).

## OAuth2

Sample configurations for setting up OAuth validation with the following identity providers.

### Google

```bash
$ make google
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
$ docker-compose exec redis redis-cli KEYS cachedoauth:*
1) "cachedoauth:XXXXXXXXXXXXXX:www.googleapis.com"

# view the info cached for this token
$ docker-compose exec redis redis-cli HGET cachedoauth:XXXXXXXXXXXXXX:www.googleapis.com token_json

# verify the TTL for the cached info in Redis
$ docker-compose exec redis redis-cli TTL cachedoauth:XXXXXXXXXXXXXX:www.googleapis.com
(integer) <seconds>
```

### Facebook
to be added

### Twitter
to be added

## Benchmark

The current benchmark focuses on testing an end-to-end authorization flow with an OAuth provider such as Google, also invoking the validation framework. The results highlight the performance of the validation framework and NGINX/Openresty, all together.

To start the API Gateway, its Redis dependency, and a sample microservice execute:
```bash
$ make benchmark
```

The setup for benchmarking assumes the machine has `4` CPUS available for docker; the API GW uses the first 2, so that `wrk` uses the last 2. Redis and the sample microservices shares any of them.

Once `docker-compose` is started, execute perf tests using `wrk` :

```bash
$ docker run --cpuset-cpus=2-3 --net=host --rm williamyeh/wrk:4.0.1 -t2 -c500 -d30s http://localhost/api/echo/headers -H "Authorization: Bearer <replace-me-with-a-google-token>"
```

> Follow the [instructions](#google) above to get a Google token.

You should see an output like the following:
```
Running 30s test @ http://localhost/api/echo/headers
  2 threads and 500 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    50.75ms  125.62ms   1.32s    93.15%
    Req/Sec    10.83k     2.07k   16.91k    80.77%
  644553 requests in 30.09s, 176.39MB read
  Socket errors: connect 0, read 0, write 0, timeout 368
Requests/sec:  21424.28
Transfer/sec:      5.86MB
```

> This output was generated by executing the benchmark test on a MAC with i7 CPU @2.7Ghz, Docker Version 17.03.1-ce-mac12 (17661), and docker-compose version 1.11.2, build dfed245.

### Debugging the test
To debug the response of the HTTP request used in the tests issue a simple curl command :

```
$ docker run --net=host --rm appropriate/curl http://localhost/api/echo/headers -H "Authorization: Bearer <replace-me-with-a-google-token>" -sSL

OK
```

If the Oauth token is correct the response should say `OK`, otherwise it should say `{"error_code":"401013","message":"Oauth token is not valid"}`.
