#!/bin/bash

# Script parameters from arguments
elkstack=$1
elkserverstatus=($2)
beatstatus=($3)
servicestatus=($4)
HostIP=$(dig +short myip.opendns.com @resolver1.opendns.com)
elkserver=HostIP
elkbeats=HostIP

echo $elkstack
echo $elkserverstatus
echo $beatstatus
echo $servicestatus

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


#elkserver
els_status=${elkserverstatus[0]}
ks_status=${elkserverstatus[1]}
lgstash_status=${elkserverstatus[2]}
es_state=${els_status#*_}
kibana_status=${ks_status#*_}
logstash_status=${lgstash_status#*_}

echo $es_state $kibana_status $logstash_status

#for beats
fileb_status=${beatstatus[0]}
pktbeat_status=${beatstatus[1]}
metricbt_status=${beatstatus[2]}

filebeat_status=${fileb_status#*_}
packetbeat_status=${pktbeat_status#*_}
metricbeat_status=${metricbt_status#*_}

echo $filebeat_status $packetbeat_status $metricbeat_status

#for services
ngin_stat=${servicestatus[0]}
apache_stat=${servicestatus[1]}
msql_stat=${servicestatus[2]}

nginx_status=${ngin_stat#*_}
apache_status=${apache_stat#*_}
mysql_status=${msql_stat#*_}

echo $nginx_status $apache_status $mysql_status

es_state='present'
kibana_status='present'
logstash_status='present'
filebeat_status='present'
packetbeat_status='present'
metricbeat_status='present'
nginx_status='present'
apache_status='present'
mysql_status='present'

## add condition for installing beats and server. 
HOME=/root ansible-playbook /home/elkstack/elkdocker_install.yml  --extra-vars "HostIP=$HostIP es_state=$es_state kibana_state=$kibana_status logstash_state=$logstash_status filebeat_state=$filebeat_status metricbeat_state=$metricbeat_status packetbeat_state=$packetbeat_status nginx_state=$nginx_status apache2_state=$apache_status mysql_state=$mysql_status" -vvv


