#!/bin/bash                                                                 

#Install singlebox solution
if [[ ! -f /installer/cbala-install-status ]]; then
  mkdir /opt/cafex -p

  # FAS install
  AS_INSTALLER=$(ls ./fas/*.jar)
  AS_OPTIONS=$(ls ./fas/*.advanced-install.properties)
  echo -e "\e[1;33m Installing FAS \e[0m"
  java -jar  $AS_INSTALLER -options $AS_OPTIONS

  # FCSDK install
    if [ $? -eq 0 ]; then
      SDK_INSTALLER=$(ls ./sdk/*.jar)
      SDK_OPTIONS=$(ls ./sdk/*.advanced-install.properties)
      echo -e "\e[1;33m Installing FCSDK \e[0m"
      java -jar $SDK_INSTALLER -options $SDK_OPTIONS
      else 
        exit
    fi

  # LA install
    if [ $? -eq 0 ]; then
      LA_INSTALLER=$(ls ./liveassist/*.jar)
      LA_OPTIONS=$(ls ./liveassist/*.production.properties)
      echo -e "\e[1;33m Installing Live Assist \e[0m"
      java -jar $LA_INSTALLER -options $LA_OPTIONS
      else 
        exit
    fi

  # Create check file for completed install
    if [ $? -eq 0 ]; then
      echo "completed" > /installer/cbala-install-status
      echo -e "\e[1;32m Live Assist was installation completed! \e[0m"
    else 
      exit
    fi

else 
  # Start FAS and Media Broker
  [ -f /etc/init.d/fas ] && /etc/init.d/fas start || echo $'No fas service file found.\nDelete /installer/cbala-install-status to re-install'
  [ -f /etc/init.d/fusion_media_broker ] && /etc/init.d/fusion_media_broker start || echo $'No media broker service file found.\nDelete /installer/cbala-install-status  to re-install'                          
fi

if (( $(ps -ef | grep -v grep | grep fas | wc -l) > 0 )) && \
  (( $(ps -ef | grep -v grep | grep media_broker | wc -l) > 0 )); then
  echo " 
   ___  ___    _     _     _               _            _      _   
  / __|| _ )  /_\   | |   (_)__ __ ___    /_\   ___ ___(_) ___| |_ 
 | (__ | _ \ / _ \  | |__ | |\ V // -_)  / _ \ (_-<(_-<| |(_-<|  _|
  \___||___//_/ \_\ |____||_| \_/ \___| /_/ \_\/__//__/|_|/__/ \__|
                                                                    
  "
  echo -e "\e[1;32m Live Assist components are running! \e[0m" 
  else 
      echo -e "\e[1;31m There was a problem starting all CBA Live Assist components."
      exit

fi

exec /usr/sbin/init 
