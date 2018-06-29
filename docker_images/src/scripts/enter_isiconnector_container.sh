#!/bin/bash
sudo docker exec -i -t $(sudo docker ps| grep 'isilon-data-insights-connector' | awk '{print $1}') /bin/bash
