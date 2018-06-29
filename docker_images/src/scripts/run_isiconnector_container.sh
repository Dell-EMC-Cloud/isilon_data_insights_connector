#!/bin/bash
docker run --privileged -d=true -v /data/influxdb:/var/lib/influxdb --restart unless-stopped --net=host --name=isilon-data-insights-connector emccorp/isilon-data-insights-connector:1.0.0 
