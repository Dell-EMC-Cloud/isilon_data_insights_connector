# Isilon Data Insights Connector docker image build

This is the source to build a docker image containing the Isilon Data Insights Connector and InfluxDB

To isntall and configure the image:
  1. Download the docker image: docker pull emccorp/isilon-data-insights-connector 
  2. Start the docker image. To create and run the container, mapping the default InfluxDB data directory to /data/influxdb, run:
     
     docker run --privileged -d=true -v /data/influxdb:/var/lib/influxdb --restart unless-stopped --net=host --name=isilon-data-insights-connector emccorp/isilon-data-insights-connector:1.0.0

  3. Enter the docker container. 

     sudo docker exec -i -t $(sudo docker ps| grep 'isilon-data-insights-connector' | awk '{print $1}') /bin/bash

  4. Configure the Isilon connector.
     a. Copy /opt/isilon_data_insights_connector/example_isi_data_insights_d.cfg to /opt/isilon_data_insights_connector/isi_data_insights_d.cfg 
     b. Edit isi_data_insights_d.cfg. Add the Isilon cluster information to the clusters: line as directored in the file.
     c. Run: systemctl enable isiconnector
     d. Run: systemctl start isiconnector


