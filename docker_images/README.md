# Isilon Data Insights Connector docker image build

This is the source to build a docker image containing the Isilon Data Insights Connector and InfluxDB

To use the image:
  1. Download the pixz zipped image and unzip it or clone this repo and cd to the docker_images/src/docker dir and run build.sh 
  2. Load the docker image. For instance:  docker load -i <imagefilename>
  3. Start the docker image. To create and run the container, mapping the default InfluxDB data directory to /data/influxdb, run:
     
     docker run --privileged -d=true -v /data/influxdb:/var/lib/influxdb --restart unless-stopped --net=host --name=isi-connector isi-connector:1.0.0

  4. Enter the docker container. 

     sudo docker exec -i -t $(sudo docker ps| grep 'isi-connector' | awk '{print $1}') /bin/bash

  5. Configure the Isilon connector.
     a. Copy /opt/isilon_data_insights_connector/example_isi_data_insights_d.cfg to /opt/isilon_data_insights_connector/isi_data_insights_d.cfg 
     b. Edit isi_data_insights_d.cfg. Add the Isilon cluster information to the clusters: line as directored in the file.
     c. Run: systemctl enable isiconnector
     d. Run: systemctl start isiconnector

NOTE: There is a deployment script that performs these steps in docker_images/src/scripts. Modify as needed and run from the scripts directory: 
      
      ./deployment.sh DeployIsilonConnector


