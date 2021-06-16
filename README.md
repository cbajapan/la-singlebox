# la-singlebox installation

These files will assist you to setup up a CBA Live Assist singlebox solution *for testing/demonstration purposes only*

## You will need

- Docker installed and running - Windows or Linux (due to limitations on Docker desktop for Mac this is not supported)
- FAS, FCSDK and Liveassist installation zip files from the reseller portal
- Media broker .gz file from the reseller portal

## Getting Docker installed

For Windows 10 systems please follow the instructions to install Docker Desktop:  
<https://docs.docker.com/docker-for-windows/install/>  
For Linux systems, use one of the supported platforms and follow along here:  
<https://docs.docker.com/engine/install/#server>

### Build the installer folder

1. Clone this repo (or download the contents to a new folder)
2. Copy the FAS, FCSDK and Liveassist zip files to the /installer folder
3. Add the **media broker.gz** and **pluggable_cli_main.jar** files to the /installer folder
4. Your folder should then look something like this:

```bash
.
├── .env-example
├── docker-compose.yml
└── installer
    ├── as-installer-x.x.xx.zip
    ├── cafex_live_assist_installer-x.xx.x.zip
    ├── fusion_client_core_sdk_installer-x.x.xx.zip
    ├── install-la-singlebox.sh
    └── media-broker-native-el7-x86_64-xx.tar.gz
```

### Edit the **.env** file to suit your environment

- Rename or copy the `.env-example` file to be `.env`
- Change the CLUSTER_ADDRESS to your docker hosts' reachable IP or DNS
- **NB:** If you change the FAS_BIND_ADDRESS (default 172.16.0.2) you may also need to update the DOCKER_NET and DOCKER_NET_GATEWAY values to match

```bash
CLUSTER_ADDRESS=YOUR.EXT.IP.ADDR
FAS_BIND_ADDRESS=172.20.0.10
DOCKER_NET=172.20.0.0/24   
DOCKER_NET_GATEWAY=172.20.0.1
JDK_PATH=/usr/java/latest
ADMIN_USER=administrator
ADMIN_PASSWORD=administrator
FCSDK_PACKS=COMMON,GATEWAY,CORE_SDK,SAMPLE_APP,MEDIABROKER
LA_PACKS=ASSIST,ASSIST_SDK
```

### Run docker-compose

Make sure you are in the root of your newly created folder

- To start the base image pull and installation run:  
`docker-compose up` (FYI: It takes around 15 min to complete the first time, depending on internet speed)
- This will pull down a base image and start the installation of your singlebox solution in a new docker container allwoing you to watch it interactively)
- Once the FAS and MB services are started, press `Ctrl-c` to shut down the container
- To start the singlebox container (running in *detached* mode) run:  
`docker-compose up -d`
- To stop the container run:  
`docker-compose stop`
- To delete the container and network run:  
`docker-compose down`
- Delete the **/installer/cbala-install-status** file if you would like to run the installation again before you create a new container
