#!/bin/bash
sudo docker exec -i -t $(sudo docker ps| grep 'isi-connector' | awk '{print $1}') /bin/bash
