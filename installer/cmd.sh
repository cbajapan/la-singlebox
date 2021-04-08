#!/bin/bash 

#Install singlebox solution
if [[ ! -f /installer/cbala-install-status ]]; then
mkdir /opt/cafex -p

# FAS install
AS_INSTALLER=$(ls ./fas/*.jar)
AS_OPTIONS=$(ls ./fas/*.advanced-install.properties)
java -jar  $AS_INSTALLER -options $AS_OPTIONS

# SDK install
SDK_INSTALLER=$(ls ./sdk/*.jar)
SDK_OPTIONS=$(ls ./sdk/*.advanced-install.properties)
java -jar $SDK_INSTALLER -options $SDK_OPTIONS

# LA install
LA_INSTALLER=$(ls ./liveassist/*.jar)
LA_OPTIONS=$(ls ./liveassist/*.production.properties)
java -jar $LA_INSTALLER -options $LA_OPTIONS

# Create check file for completed install
echo "completed" > /installer/cbala-install-status

fi

# Stop and start FAS and Media Broker
service fas restart
service fusion_media_broker restart

exec /usr/sbin/init