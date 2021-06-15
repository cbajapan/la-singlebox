#!/bin/bash

#Install singlebox solution
if [[ ! -f /installer/cbala-install-status ]]; then
  mkdir /opt/cafex -p
  
  # FAS install
  AS_INSTALLER=$(ls ./fas/*.jar)
  AS_OPTIONS=$(ls ./fas/*.advanced-install.properties)
  
  sed -ri -e "s/(accept\.eula=).*/\1true/g" \
  -e "s/(JDKPath=).*/\1${JDK_PATH//\//\\/}/g" \
  -e "s/(bind\.address.*=).*/\1$FAS_BIND_ADDRESS/g" \
  -e "s/(cluster\.address=).*/\1$CLUSTER_ADDRESS/g" \
  $AS_OPTIONS
  
  echo -e "\e[1;33mInstalling FAS: \e[0m"
  java -jar  $AS_INSTALLER -options $AS_OPTIONS

  # FCSDK install
  if [ $? -eq 0 ]; then
      SDK_INSTALLER=$(ls ./sdk/*.jar)
      SDK_OPTIONS=$(ls ./sdk/*.advanced-install.properties)
      MB_INSTALLER=$(ls -d $PWD/media-broker-native-*)
      
      sed -ri -e "s/(accept\.eula=).*/\1true/g" \
      -e "s/(JDKPath=).*/\1${JDK_PATH//\//\\/}/g" \
      -e "s/(packs=).*/\1$FCSDK_PACKS/g" \
      -e "s/(appserver\.admin\.address=).*/\1$FAS_BIND_ADDRESS/g" \
      -e "s/(gateway\.controlled_domain=).*/\1$CLUSTER_ADDRESS/g" \
      -e "s/(rtp_proxy_native\.tarball.file=).*/\1${MB_INSTALLER//\//\\/}/g" \
      $SDK_OPTIONS
      
      echo -e "\e[1;33mInstalling FCSDK: \e[0m"
      java -jar $SDK_INSTALLER -options $SDK_OPTIONS
      else
        exit
    fi

  # LA install
    if [ $? -eq 0 ]; then
      LA_INSTALLER=$(ls ./liveassist/*.jar)
      LA_OPTIONS=$(ls ./liveassist/*.production.properties)
      
      sed -ri -e "s/(accept\.eula=).*/\1true/g" \
      -e "s/(JDKPath=).*/\1${JDK_PATH//\//\\/}/g" \
      -e "s/(packs=).*/\1$LA_PACKS/g" \
      -e "s/(appserver\.admin\.address=).*/\1$FAS_BIND_ADDRESS/g" \
      $LA_OPTIONS
      
      echo -e "\e[1;33mInstalling Live Assist: \e[0m"
      java -jar $LA_INSTALLER -options $LA_OPTIONS
      else
        exit
    fi

  # Create check file for completed install
    if [ $? -eq 0 ]; then
      echo "completed" > /installer/cbala-install-status
      echo -e "\e[1;32mLive Assist installation completed! \e[0m"
    else
      exit
    fi

else
  # Start FAS and Media Broker if install check file is created
  [ -f /etc/init.d/fas ] && /etc/init.d/fas start || \
  echo -e "\e[1;31mNo fas service file found.\nDelete /installer/cbala-install-status to re-install. \e[1;31m"
  [ -f /etc/init.d/fusion_media_broker ] && /etc/init.d/fusion_media_broker start || \
  echo -e "\e[1;31mNo media broker service file found.\nDelete /installer/cbala-install-status to re-install. \e[1;31m"                         
fi

if (( $(ps -ef | grep -v grep | grep fas | wc -l) > 0 )) && \
  (( $(ps -ef | grep -v grep | grep media_broker | wc -l) > 0 )); then
  echo " 
   ___  ___    _     _     _               _            _      _   
  / __|| _ )  /_\   | |   (_)__ __ ___    /_\   ___ ___(_) ___| |_ 
 | (__ | _ \ / _ \  | |__ | |\ V // -_)  / _ \ (_-<(_-<| |(_-<|  _|
  \___||___//_/ \_\ |____||_| \_/ \___| /_/ \_\/__//__/|_|/__/ \__|
                                                                    
  "
  echo -e "\e[1;32mLive Assist components are running! \e[0m" 
  else
      echo -e "\e[1;31mThere was a problem starting all CBA Live Assist components. \e[0m"
      exit
fi

exec /usr/sbin/init
