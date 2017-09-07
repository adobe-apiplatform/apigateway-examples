This example shows how to invoke a Lambda function directly from the API Gateway. It also shows how to extend an existing microservice with a Lambda function. The result, from the client perspective, looks like a consistent API, even though
behind the scenes, the request goes to multiple backends.

## How to run this example

### Configure an AWS Lambda function

Define a new Lambda function using the code from [hello-world.js](./hello-world.js).

Once the function is saved, note the ARN of this function.

### Configure AWS Credentials

For simplicity, this demo uses Basic Credentials to authenticate with AWS.
Define the following environment variables:

```bash
$ export AWS_ACCESS_KEY_ID=#change-me
$ export AWS_SECRET_ACCESS_KEY=#change-me
$ export AWS_FUNCTION=#arn-of-the-function (i.e. arn:aws:lambda:us-east-1:99999999:function:hello-world)
```

### Start the API Gateway

``` bash
$ make aws-lambda
```

This  command starts the API Gateway, a microservice, exposing an API Facade for both:
* `/api/hello` invokes the AWS Lambda function using the [lambda_invoker.lua](./lambda_invoker.lua) script.
* `/api/echo` proxies all the other requests to a microservice.

The configuration for these endpoints is found in [endpoints.conf](./endpoints.conf).


### Invoke the Lambda function

```bash
$ curl localhost/api/hello

# the result should be:
# {"payload":"Hello, stranger from somewhere !"}
```

```bash
$ curl "localhost/api/hello?name=yall&place=texas"

# the result should be:
# {"payload":"Hello, yall from texas !"}
```


### Invoke other endpoints that go to an existing microservice

```bash
$ curl localhost/api/echo/headers

# the result should be:
# Accept=[*/*]
# Connection=[close]
# Host=[microservice]
# User-Agent=[curl/7.51.0]
```
