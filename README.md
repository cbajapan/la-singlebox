# la-singlebox installation
These files will assist you to setup up a CBA Live Assist singlebox solution *for testing/demonstration purposes only*

### You will need:
- Docker installed and running - Windows or Linux (due to limitations on Docker desktop for Mac this is not supported)
- FAS, FCSDK and Liveassist installation zip files from the reseller portal
- Media broker gz file from the reseller portal

### Getting Docker installed:
For Windows 10 systems please follow the instructions to install Docker Desktop:  
https://docs.docker.com/docker-for-windows/install/  
For Linux systems, use one of the supported platforms and follow along here:  
https://docs.docker.com/engine/install/#server

### Build the installer folder:
1. Clone this repo to a new folder (or download the contents)
2. Extract the FAS, FCSDK and Liveassist zip files to their respective folders under the /installer folder
3. Add the **media broker .gz** file to the /installer folder
4. Edit the **.properties** files for each install to suit your environment:  
[**NB:** For all files, leave the local IP of the fas server as 172.16.0.2]  
**as-installer-x.x.x.advanced-install.properties**  
`accept.eula=yes`  
`JDKPath=/usr/java/latest`  
`bind.address.service=172.16.0.2`  
`bind.address.management=172.16.0.2`  
`cluster.address=[your external IP / FQDN]`  
**fusion_client_core_sdk_installer-x.x.x.advanced-install.properties**  
`accept.eula=yes`  
`JDKPath=/usr/java/latest`  
`packs=COMMON,GATEWAY,CORE_SDK,MEDIABROKER,SAMPLE_APP`  
`appserver.admin.address=172.16.0.2`  
`gateway.controlled_domain=[your external IP / FQDN]`  
`rtp_proxy_native.tarball.file=/installer/media-broker-native-el7-x86_64-11.tar.gz`  
**cafex_live_assist_installer-x.x.x.production.properties**  
`accept.eula=yes`  
`JDKPath=/usr/java/latest`  
`appserver.admin.address=172.16.0.2`
5. Your folder should look something like this:
````
.
├── docker-compose.yml
├── dockerfile
└── installer
    ├── cmd.sh
    ├── fas
    │   ├── as-installer-2.5.21.advanced-install.properties
    │   ├── as-installer-2.5.21.jar
    │   ├── as-installer-2.5.21.quick-install.properties
    │   ├── as-installer-2.5.21.upgrade-install.properties
    │   └── log4j.properties
    ├── liveassist
    │   ├── EULA.txt
    │   ├── cafex_live_assist_installer-1.64.3.jar
    │   ├── cafex_live_assist_installer-1.64.3.production.properties
    │   ├── cafex_live_assist_installer-1.64.3.trial_environment.properties
    │   └── log4j.properties
    ├── media-broker-native-el7-x86_64-11.tar.gz
    └── sdk
        ├── EULA.txt
        ├── fusion_client_core_sdk_installer-3.3.17.advanced-install.properties
        ├── fusion_client_core_sdk_installer-3.3.17.jar
        ├── fusion_client_core_sdk_installer-3.3.17.quick-install.properties
        ├── fusion_client_core_sdk_installer-3.3.17.upgrade-install.properties
        └── log4j.properties
        
````
### Run docker-compose:
Make sure you are in the root of your newly created folder.
- To start the image pull and installation run:  
`docker-compose up` (FYI: It takes around 15 min to complete the first time, depending on internet speed)
- This will pull down a base image and start the installation of your singlebox solution in a new docker container allwoing you to watch it interactively)
- Once the FAS and MB services are restarted, press `Ctrl-c` to shut down the container
- To start the singlebox container (running in *detached* mode) run:  
`docker-compose up -d`		
- To stop the container run:  
`docker-compose stop`
- To delete the container and network run:  
`docker-compose down`
- Delete the **/installer/cbala-install-status** file if you would like to run the installation again before you create a new container
