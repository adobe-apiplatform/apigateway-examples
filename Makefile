.PHONY:before-test
before-test:
	mkdir -p ${HOME}/tmp/apigateway-examples/environment.conf.d
	rm -rf ${HOME}/tmp/apigateway-examples/environment.conf.d/*
	cp -r `pwd`/common/environment.conf.d/* ${HOME}/tmp/apigateway-examples/environment.conf.d/

.PHONY:google
google: before-test
	mkdir -p ${HOME}/tmp/apigateway-examples/conf
	rm -rf ${HOME}/tmp/apigateway-examples/conf/*
	cp -r `pwd`/oauth2/google/simple-config/*  ${HOME}/tmp/apigateway-examples/conf/
	docker-compose --project-name apigateway-examples up

.PHONY: benchmark
benchmark: before-test
	mkdir -p ${HOME}/tmp/apigateway-examples/conf
	rm -rf ${HOME}/tmp/apigateway-examples/conf/*
	cp -r `pwd`/oauth2/google/simple-config/*  ${HOME}/tmp/apigateway-examples/conf/
	cp -r `pwd`/benchmark/*  ${HOME}/tmp/apigateway-examples/conf/
	docker-compose --file docker-compose-benchmark.yaml up

.PHONY: aws-lambda
aws-lambda: before-test
	mkdir -p ${HOME}/tmp/apigateway-examples/conf
	rm -rf ${HOME}/tmp/apigateway-examples/conf/*
	echo " \
	 # set by Makefile \
	" >> ${HOME}/tmp/apigateway-examples/environment.conf.d/api-gateway-env-vars.server.conf
	echo set \$$aws_access_key_id ${AWS_ACCESS_KEY_ID}\; >> ${HOME}/tmp/apigateway-examples/environment.conf.d/api-gateway-env-vars.server.conf
	echo set \$$aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}\; >> ${HOME}/tmp/apigateway-examples/environment.conf.d/api-gateway-env-vars.server.conf
	echo set \$$aws_function ${AWS_FUNCTION}\; >> ${HOME}/tmp/apigateway-examples/environment.conf.d/api-gateway-env-vars.server.conf
	cp -r `pwd`/serverless-router/aws-lambda/*  ${HOME}/tmp/apigateway-examples/conf/
	cat ${HOME}/tmp/apigateway-examples/environment.conf.d/api-gateway-env-vars.server.conf
	docker-compose --project-name apigateway-examples up
