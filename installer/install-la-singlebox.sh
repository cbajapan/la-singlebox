#!/bin/bash

#Install singlebox solution
if [[ ! -f /installsrc/cbala-install-status ]]; then
  mkdir /opt/fusion -p
  
  # FAS install
  unzip -o /installsrc/fas-core-installer-*.zip -d ./fas
  AS_INSTALLER=$(ls ./fas/*.jar)
  AS_OPTIONS=$(ls ./fas/*advanced-install.properties)
  # Edit options file
  sed -ri -e "s/(accept\.eula=).*/\1true/g" \
  -e "s/(JDKPath=).*/\1${JDK_PATH//\//\\/}/g" \
  -e "s/(bind\.address\.service=).*/\1$FAS_MASTER_ADDRESS/g" \
  -e "s/(bind\.address\.management=).*/\1$FAS_MASTER_ADDRESS/g" \
  -e "s/(admin\.user=).*/\1$ADMIN_USER/g" \
  -e "s/(admin\.password=).*/\1$ADMIN_PASSWORD/g" \
  -e "s/(cluster\.address=).*/\1$CLUSTER_ADDRESS/g" \
  $AS_OPTIONS
  
  echo -e "\e[1;33mInstalling FAS: \e[0m"
  ulimit -c unlimited
  java -jar  $AS_INSTALLER -options $AS_OPTIONS

  # FCSDK install
  if [ $? -eq 0 ]; then
      unzip -o /installsrc/fusionweb-installer-*.zip -d ./sdk
      SDK_INSTALLER=$(ls ./sdk/*.jar)
      SDK_OPTIONS=$(ls ./sdk/*advanced-install.properties)
      MB_INSTALLER=$(ls -d ./sdk/media-broker-native-*)
      # Edit options file
      # (FYI - bypassing os check below for compatibility)
      sed -ri -e "s/(accept\.eula=).*/\1true/g" \
      -e "s/(JDKPath=).*/\1${JDK_PATH//\//\\/}/g" \
      -e "s/(packs=).*/\1$FCSDK_PACKS/g" \
      -e "s/(appserver\.admin\.address=).*/\1$FAS_MASTER_ADDRESS/g" \
      -e "s/(appserver\.admin\.user.*=).*/\1$ADMIN_USER/g" \
      -e "s/(appserver\.admin\.password.*=).*/\1$ADMIN_PASSWORD/g" \
      -e "s/(rest\.appserver\.address=).*/\1$FAS_MASTER_ADDRESS/g" \
      -e "s/(client_sdk\.runtime\.management_server\.address=).*/\1$FAS_MASTER_ADDRESS/g" \
      -e "s/(client_sdk\.runtime\.management_server.\user=).*/\1$ADMIN_USER/g" \
      -e "s/(client_sdk\.runtime\.management_server.\password=).*/\1$ADMIN_PASSWORD/g" \
      -e "s/(gateway\.controlled_domain=).*/\1$FAS_MASTER_ADDRESS/g" \
      -e "s/(rtp_proxy_native\.tarball.file=).*/\1${MB_INSTALLER//\//\\/}/g" \
      -e "s/(oschecks\.problems\.ignore=).*/\1true/g" \
      $SDK_OPTIONS
      
      echo -e "\e[1;33mInstalling FCSDK: \e[0m"
      java -jar $SDK_INSTALLER -options $SDK_OPTIONS

      # Register the mediabroker & configure
      chmod +x /installsrc/mb-singlebox-register.sh && /installsrc/mb-singlebox-register.sh
      else
        exit
    fi

  # LA install
    if [ $? -eq 0 ]; then
      unzip -o /installsrc/fusion-live-assist-core-installer-*.zip -d ./liveassist
      LA_INSTALLER=$(ls ./liveassist/*.jar)
      LA_OPTIONS=$(ls ./liveassist/*production-install.properties)
      # Edit options file
      sed -ri -e "s/(accept\.eula=).*/\1true/g" \
      -e "s/(JDKPath=).*/\1${JDK_PATH//\//\\/}/g" \
      -e "s/(packs=).*/\1$LA_PACKS/g" \
      -e "s/(appserver\.admin\.address=).*/\1$FAS_MASTER_ADDRESS/g" \
      -e "s/(appserver\.admin\.user=).*/\1$ADMIN_USER/g" \
      -e "s/(appserver\.admin\.password=).*/\1$ADMIN_PASSWORD/g" \
      $LA_OPTIONS
  #          -e "s/(cli\.dir=).*/\1\/opt\/fusion\/cli/g" \
      echo -e "\e[1;33mInstalling Live Assist: \e[0m"
      java -jar $LA_INSTALLER -options $LA_OPTIONS

      # Enable Anonymous Agent Access in LA
      chmod +x /installsrc/mb-singlebox-register.sh && /installsrc/la-singlebox-enable-anon-agents.sh
      else
        exit
    fi

  # Create check file for completed install
    if [ $? -eq 0 ]; then
      echo "completed" > /installsrc/cbala-install-status
      echo -e "\e[1;32mLive Assist installation completed! \e[0m"
      else
        exit
    fi

else
  # Start FAS and Media Broker if install check file is created
  [ -f /etc/init.d/fas ] && /etc/init.d/fas start || \
  echo -e "\e[1;31mNo fas service file found.\nDelete ./installer/cbala-install-status to re-install. \e[1;31m"
  [ -f /etc/init.d/fusion_media_broker ] && /etc/init.d/fusion_media_broker start || \
  echo -e "\e[1;31mNo media broker service file found.\nDelete ./installer/cbala-install-status to re-install. \e[1;31m"                         
fi

if (( $(ps -ef | grep -v grep | grep fas | wc -l) > 0 )) && \
  (( $(ps -ef | grep -v grep | grep media_broker | wc -l) > 0 )); then
  echo "   ___ ___   _     _    _             _          _    _   ";
  echo "  / __| _ ) /_\   | |  (_)_ _____    /_\   _____(_)__| |_ ";
  echo " | (__| _ \/ _ \  | |__| \ V / -_)  / _ \ (_-<_-< (_-<  _|";
  echo "  \___|___/_/ \_\ |____|_|\_/\___| /_/ \_\/__/__/_/__/\__|";
  echo "                                                          ";
  echo -e "\e[1;32mLive Assist components are running! \e[0m"
  echo "=========================================================="
  echo "You can access the system by following urls"
  echo "     https://"${CLUSTER_ADDRESS}":8443/assistsample"
  echo "     https://"${CLUSTER_ADDRESS}":8443/agent/console"
  echo "     https://"${CLUSTER_ADDRESS}":8443/web_plugin_framework/webcontroller"
  echo "     https://"${CLUSTER_ADDRESS}":8443/csdk-sample"
  echo -e "\e[1;33mDon't forget to check MediaBroker's ip address settings: \e[0m"
  echo "     https://"${CLUSTER_ADDRESS}":8443/web_plugin_framework/webcontroller/mediabrokers/"
  echo "=========================================================="
  else
      echo -e "\e[1;31mThere was a problem starting all CBA Live Assist components. \e[0m"
      exit
fi

exec /usr/sbin/init
