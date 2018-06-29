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
docker build -t isi-connector:$VERSION --file Dockerfile --force-rm .

docker save --output build/isi-connector.$VERSION.tar isi-connector:$VERSION
pixz -e9 -i build/isi-connector.$VERSION.tar -o build/isi-connector.$VERSION.txz
#mv build/isi-connector.$VERSION.* ../../images/.

