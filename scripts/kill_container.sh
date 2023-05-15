#!/bin/bash
echo "Stopping and removing the running container"
cd ~
export AWS_ACCOUNT_ID=AWS_ACCOUNT_ID_ENV
export AWS_DEFAULT_REGION=AWS_DEFAULT_REGION_ENV
export AWS_IMAGE_REPO_NAME=AWS_IMAGE_REPO_NAME_ENV
export AWS_IMAGE_TAG=AWS_IMAGE_TAG_ENV
docker-compose stop
docker-compose rm -f