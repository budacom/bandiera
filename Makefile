REPO := bandiera
export VERSION ?= develop
export VERSION_MYSQL ?= develop
DOCKER_COMPOSE_YML ?= docker-compose.yml

export PATH := $(PATH):$(PWD)/.gcloud/google-cloud-sdk/bin/
SHELL := /bin/bash

docker-login:
	@if [ ! $$(which gcloud) ] || [ ! $$(which kubectl) ]; then \
	  mkdir -p .gcloud; \
	  cd .gcloud; \
	  curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-200.0.0-darwin-x86_64.tar.gz -o google-cloud-sdk-200.0.0-darwin-x86_64.tar.gz -L; \
	  tar zxf google-cloud-sdk-200.0.0-darwin-x86_64.tar.gz; \
	  ./google-cloud-sdk/install.sh --additional-components gcloud kubectl --usage-reporting false -q; \
	fi;
	@if [ $$(gcloud auth list --format='value(account)' 2> /dev/null | grep @ > /dev/null; echo $$?) != 0 ]; then \
	  gcloud auth login; \
	fi;
	@echo ""
	@echo Using google account: $$(gcloud auth list --format='value(account)' 2> /dev/null)
	@echo For using another account run: make gcloud-revoke
	@echo ""
	gcloud auth configure-docker -q;
	gcloud container clusters get-credentials apps-staging --zone us-east1-b --project buda-default-staging || echo No tienes permiso para staging

staging-logs:
	kubectl --context gke_buda-default-staging_us-east1-b_apps-staging -n ${REPO}-staging logs -f $$(kubectl --context gke_buda-default-staging_us-east1-b_apps-staging -n ${REPO}-staging get pods -o name -l app=${REPO} --sort-by=.status.startTime | tail -n1) -c ${REPO}

staging-console:
	kubectl --context gke_buda-default-staging_us-east1-b_apps-staging -n ${REPO}-staging exec -it $$(kubectl --context gke_buda-default-staging_us-east1-b_apps-staging -n ${REPO}-staging get pods -o name -l app=${REPO} --sort-by=.status.startTime | tail -n1 | cut -d / -f 2-) -c ${REPO} bash

staging-logs:
	kubectl --context gke_buda-default-staging_us-east1-b_apps-staging -n ${REPO}-staging logs -f $$(kubectl --context gke_buda-default-staging_us-east1-b_apps-staging -n ${REPO}-staging get pods -o name -l app=${REPO} --sort-by=.status.startTime | tail -n1) -c ${REPO}

staging-console:
	kubectl --context gke_buda-default-staging_us-east1-b_apps-staging -n ${REPO}-staging exec -it $$(kubectl --context gke_buda-default-staging_us-east1-b_apps-staging -n ${REPO}-staging get pods -o name -l app=${REPO} --sort-by=.status.startTime | tail -n1 | cut -d / -f 2-) -c ${REPO} bash

gcloud-revoke:
	gcloud auth revoke

mysql-rm: down
	docker volume rm ${REPO}-$(subst .,,$(VERSION))_mysql_data

mysql-init:
	# docker-compose -p ${REPO}-${VERSION} -f ${DOCKER_COMPOSE_YML} up mysql_import
	docker-compose -p ${REPO}-${VERSION} -f ${DOCKER_COMPOSE_YML} up -d mysql
	#docker-compose -p ${REPO}-${VERSION} -f ${DOCKER_COMPOSE_YML} up mysql_migrate

build:
	docker build . -t us.gcr.io/ops-support-191021/${REPO}:${VERSION}

up: mysql-init
	docker-compose -p ${REPO}-${VERSION} -f ${DOCKER_COMPOSE_YML} up mysql ${REPO}

down:
	docker-compose -p ${REPO}-${VERSION} -f ${DOCKER_COMPOSE_YML} down

bash:
	docker-compose -p ${REPO}-${VERSION} -f ${DOCKER_COMPOSE_YML} run --entrypoint bash ${REPO}

console:
	docker-compose -p ${REPO}-${VERSION} -f ${DOCKER_COMPOSE_YML} run ${REPO} rails console
