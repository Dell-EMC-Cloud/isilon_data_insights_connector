#!/bin/bash
docker run --privileged -d=true -v /data/influxdb:/var/lib/influxdb --restart unless-stopped --net=host --name=isi-connector isi-connector:1.0.0 
