#!/bin/bash
echo "Pull and start docker images"
export AWS_ACCOUNT_ID=AWS_ACCOUNT_ID_ENV
export AWS_DEFAULT_REGION=AWS_DEFAULT_REGION_ENV
export AWS_IMAGE_REPO_NAME=AWS_IMAGE_REPO_NAME_ENV
export AWS_IMAGE_TAG=AWS_IMAGE_TAG_ENV
cd ~
docker-compose pull
docker-compose up -d