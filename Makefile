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
