#!/bin/bash

# Script parameters from arguments
elkstack=$1
elkserverstatus=$2
beatstatus=$3
servicestatus=$4
HostIP=$(dig +short myip.opendns.com @resolver1.opendns.com)
elkserver=HostIP
elkbeats=HostIP
# filebeat_status="absent"
# metricbeat_status="present"
# packetbeat_status="absent"
# beatversion="6.2.3"
# beats_output="elasticsearch"
# nginx_status="present"
# apache_status="absent"
# mysql_status="present"

apt-get update
apt-get install software-properties-common -y
apt-add-repository ppa:ansible/ansible -y
apt-get update
apt-get install ansible -y
apt-get install unzip -y

cd /home/

if [ -e elkstack.* ];
then
 if [ -d /home/elkstack ];
 then
       rm -rf elkstack.*
rm -rf /home/elkstack
	echo "directory delete"
 fi  
fi
wget $elkstack
unzip elkstack.zip -d /home/elkstack/

decalre -A elkserver0=$elkserverstatus
declare -A beat0=$beatstatus
declare -A service0=$servicestatus

declare -n elkserver
for elkserver in ${!elkserver@}; do
    es_status=${elkserver[elasticsearch]}
    kibana_status=${elkserver[kibana]}
	logstash_status=${elkserver[logstash]}
done

##have to assign the variable to filebeat status.
declare -n beat
for beat in ${!beat@}; do
    filebeat_status=${beat[topbeat]}
    metricbeat_status=${beat[metricbeat]}
	packetbeat_status=${beat[packetbeat]}
done

declare -n service
for beat in ${!service@}; do
    nginx_status_status=${service[nginx]}
    apache_status_status=${service[apache]}
	mysql_status=${service[mysql]}
done

echo $filebeat_status
echo $metricbeat_status
echo $packetbeat_status

## add condition for installing beats and server. 
HOME=/root ansible-playbook /home/elkstack/elkdocker_install.yml  --extra-vars "HostIP=$HostIP es_state=$es_state kibana_state=$kibana_status logstash_state=$logstash_status filebeat_state=$filebeat_status metricbeat_state=$metricbeat_status packetbeat_state=$packetbeat_status nginx_state=$nginx_status apache2_state=$apache_status mysql_state=$mysql_status" -vvv


