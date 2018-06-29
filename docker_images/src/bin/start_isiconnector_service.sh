#!/bin/sh

echo "Starting the Isilon data collector"
cd /opt/isilon_data_insights_connector
./isi_data_insights_d.py start

