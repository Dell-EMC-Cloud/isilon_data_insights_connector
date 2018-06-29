#!/bin/bash


Usage()
{
    echo "Usage: [-h] COMMAND"
    echo "-h                     : Display usage"
    echo "Where COMMAND is one of..."
    echo "DeployIsilonConnector  : Load, run, and configure the Isilon connector docker image"

    exit 1
}

RunDockerCmd() {

    # Replace @ with " to deal with quotes within strings
    local command="`echo $* | sed s'/@/"/g'`"
    echo $command
    CMD="sudo docker $command"
    eval $CMD
    RC=$?
    return $RC
}

DeployIsilonConnector()
{
	echo "Install Isilon collector docker image."
	echo -n "Enter Y<CR> or y<CR> to continue, <CR> to exit: "
	read response
	if [ "$response" != "y" -a "$response" != "Y" ]
	then
		echo "Deployment cancelled..."
		exit 1
	fi

	echo -n "Do you want to pull the image, load a local image, or is image loaded? Enter pull or load or skip: "
	read action
	if [ -z $action ]
	then
		echo "Try again and enter pull to download, load to use local tar file, or skip to use loaded image."
		exit 1
	fi

	if [ "$action" == "pull" ]
	then
		sudo docker pull emccorp/isilon-data-insights-connector:1.0.0
	elif [ "$action" == "load" ]
	then
		echo -n "Enter the full path name of the Isilon connector docker image tar file: "
		read ImageFile
		if [ -z $ImageFile ]
		then
			echo "No image file name. Deployment cancelled..."
			exit 1
		fi

		echo "Loading Isilon connector image"
		RunDockerCmd load -i $ImageFile
	elif [ "$action" != "skip" ]
	then
		echo "Try again and enter pull to download, load to use local tar file, or skip to use loaded image."
		exit 1
	fi

	IMAGEID=`RunDockerCmd images | grep isilon-data-insights-connector | awk '{print $3}'`
	[[ -z "$IMAGEID" ]] && { echo "Failed to load Isilon connector image";  Usage; }
    
	echo "Start the Isilon connector container."
	mkdir -p /data/influxdb
	/bin/bash run_isiconnector_container.sh

	CONTAINERID=`RunDockerCmd ps -a | grep isilon-data-insights-connector | awk '{print $1}'`
	[[ -z "$CONTAINERID" ]] && { echo "Cannot determine container ID for isilon-data-insights-connector"; Usage; }

	echo "Enter the IP address of an Isilon node: "
	read IsilonIP
	[[ -z "$IsilonIP" ]] && { echo "Isilon node IP is requred."; Usage; }

	echo "Enter the user name of an Isilon REST user: "
	read IsilonUser
	[[ -z "$IsilonUser" ]] && { echo "Isilon user name is requred."; Usage; }

	echo "Enter the user password: "
	read IsilonUserPassword
	[[ -z "$IsilonUserPassword" ]] && { echo "Isilon user password is requred."; Usage; }

	cp isi_data_insights_d.cfg /tmp/isi_data_insights_d.cfg.$$
	sudo sed -i "s/ISILON_USER/$IsilonUser/" /tmp/isi_data_insights_d.cfg.$$
	sudo sed -i "s/ISILON_PW/$IsilonUserPassword/" /tmp/isi_data_insights_d.cfg.$$
	sudo sed -i "s/ISILON_IP/$IsilonIP/" /tmp/isi_data_insights_d.cfg.$$
	# Replace placeholder with updated cluster line
	RunDockerCmd cp /tmp/isi_data_insights_d.cfg.$$ $CONTAINERID:/opt/isilon_data_insights_connector/isi_data_insights_d.cfg
	rm /tmp/isi_data_insights_d.cfg.$$
	
	RunDockerCmd exec -i $CONTAINERID systemctl enable isiconnector
	RunDockerCmd exec -i $CONTAINERID systemctl start isiconnector

}

while getopts ":b:hHi" opt; do
  case $opt in
    h)
      Usage
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      Usage
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      Usage
      ;;
  esac
done
shift $((OPTIND - 1))

[[ $# == 0 ]] && Usage

if [[ $1 == 'DeployIsilonConnector' ]]
then
    DeployIsilonConnector
else
    Usage
fi
exit 0
