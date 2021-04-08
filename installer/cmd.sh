#!/bin/bash 

#Install singlebox solution
if [[ ! -f /installer/cbala-install-status ]]; then

mkdir /opt/cafex -p

java -jar ./fas/as-installer-2.5.21.jar -options ./fas/as-installer-2.5.21.advanced-install.properties 

java -jar ./sdk/fusion_client_core_sdk_installer-3.3.17.jar -options ./sdk/fusion_client_core_sdk_installer-3.3.17.advanced-install.properties

java -jar ./liveassist/cafex_live_assist_installer-1.64.3.jar -options ./liveassist/cafex_live_assist_installer-1.64.3.production.properties

# Create check file for completed install
echo "completed" > /installer/cbala-install-status

fi

# Stop and start FAS and Media Broker
service fas restart
service fusion_media_broker restart

exec /usr/sbin/init