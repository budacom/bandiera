export PATH := $(PATH):$(PWD)/.docker
SHELL := /bin/bash

docker-login:
	if [ ! $$(which gcloud) ] || [ ! $$(which kubectl) ]; then mkdir -p .gcloud; cd .gcloud; curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-200.0.0-darwin-x86_64.tar.gz -o google-cloud-sdk-200.0.0-darwin-x86_64.tar.gz -L; tar zxf google-cloud-sdk-200.0.0-darwin-x86_64.tar.gz; ./google-cloud-sdk/install.sh --additional-components kubectl --usage-reporting false -q; . ~/.bashrc; fi;
	gcloud auth configure-docker -q
	gcloud container clusters get-credentials core --zone us-east1-b --project buda-core-staging

log-staging:
	kubectl --context gke_buda-core-staging_us-east1-b_core -n bandiera-staging logs -f $$(kubectl --context gke_buda-core-staging_us-east1-b_core -n bandiera-staging get pods -o name -l app=bandiera) -c bandiera

build:
	docker build . -t bandiera

up:
	docker-compose up -d db
	docker-compose run app bundle exec rake db:migrate
	docker-compose up app