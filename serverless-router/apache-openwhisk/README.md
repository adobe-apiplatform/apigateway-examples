This example demonstrate how to use the API Gateway to build an API Facade with services running with Apache OpenWhisk.

## How to run this example

### Run OpenWhisk locally

```bash
$ git clone git@github.com:apache/incubator-openwhisk-devtools.git
$ cd incubator-openwhisk-devtools/docker-comose
$ make quick-start
```
Wait for OpenWhisk to start.

### Deploy the hello-world function in openwhisk

> This step requires `wsk` CLI to be found in the path.

```bash
$ wsk -i action create nginx-demo ./hello-demo.js --web true
```

### Configure an API Facade

Copy [endpoints.conf](./endpoints.conf) into the folder used by OpenWhisk locally.

```bash
$ cp endpoints.conf ~/tmp/openwhisk/apigateway/conf/endpoints.conf
```

In the config there's the `api/hello` location that proxies to the function:

```nginx
location /api/hello {
  proxy_pass http://whisk_controller/api/v1/web/guest/default/nginx-demo.json;
}
```

> `nginx-demo` is the name of the function created earlier.


### Invoke the function

Invoke it without parameters:
```bash
$ curl http://localhost/api/hello

# {"payload":"Hello, stranger from somewhere !"}
```

Invoke it with parameters:
```bash
curl "http://localhost/api/hello?name=yall&place=texas"
{"payload":"Hello, yall from texas !"}
```

### Stop Apache OpenWhisk

```bash
$ cd incubator-openwhisk-devtools/docker-comose
$ make destroy
```
