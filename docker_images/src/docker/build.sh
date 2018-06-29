#!/bin/bash

# Script to copy latest connector source to artifacts directory and build the docker images
# Saves the image to a tar file then zips it with pixz

# To run:
#    - update the version 
#    - cd to docker directory before running

export VERSION='1.0.0'

rm -rf artifacts/* 
rm -rf build/*

# Copy start and stop service scripts
mkdir -p artifacts/isilon_data_insights_connector/bin
cp ../bin/* artifacts/isilon_data_insights_connector/bin/.

# Copy config files for influxdb and isilon connector service
cp ../config/* artifacts/.

# Copy latest code
cp ../../../* artifacts/isilon_data_insights_connector/

# Make sure scripts are executable
chmod 755 artifacts/isilon_data_insights_connector/bin/start_isiconnector_service.sh
chmod 755 artifacts/isilon_data_insights_connector/bin/stop_isiconnector_service.sh
chmod 755 artifacts/isilon_data_insights_connector/*.py

# Build docker image and save
mkdir -p build
docker build -t emccorp/isilon-data-insights-connector:$VERSION --file Dockerfile --force-rm .

docker save --output build/isilon-data-insights-connector.$VERSION.tar emccorp/isilon-data-insights-connector:$VERSION
pixz -e9 -i build/isilon-data-insights-connector.$VERSION.tar -o build/isilon-data-insights-connector.$VERSION.txz

