This example shows how to invoke a Lambda function directly from the API Gateway.

It also shows how to route some endpoints to the Lambda backend,
and other endpoints to another microservice.
The result from the client perspective looks like a consistent API, even though
behind the scenes, the request goes to multiple backends.

## How to run this example

### Configure an AWS Lambda function

Define a new Lambda function using the code from [hello-world.js](./hello-world.js).

Once the function is saved, note the ARN of this function.

### Configure AWS Credentials

For simplicity, this demo uses Basic Credentials to authenticate with AWS.
Define 2 environment variables:

```bash
$ export AWS_ACCESS_KEY_ID=#change-me
$ export AWS_SECRET_ACCESS_KEY=#change-me
$ export AWS_FUNCTION=#arn-of-the-function (i.e. arn:aws:lambda:us-east-1:99999999:function:hello-world)
```

### Start the API Gateway

``` bash
$ make aws-lambda
```

### Invoke the Lambda function

```bash
$ curl localhost/api/hello?key1=hello-world

# the result should be:
# {"message":"hello-world"}
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
