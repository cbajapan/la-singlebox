# la-singlebox installation

### You will need:
- Docker installed and running - Windows or Linux
  - (Docker desktop for Mac not working yet!)
- FAS, FCSDK and LA installation zip files from the reseller portal
- Media broker gz file

### Build the installer folder
Use the zip file provided to you or build the installed folder as follows:
1. Extract the AS, SDK and Liveassist zip files to their respective folder under /installer
```
/fas
/sdk
/liveassist
```

2. Add the **media broker .gz** file to the /installer folder

3. Edit the **.properties** files for each install to suit your environment
- NB: For all files, leave the local IP of the fas server as 172.16.0.2 \
**as-installer-2.5.21.advanced-install.properties** \
`accept.eula=yes` \
`JDKPath=/usr/java/latest` \
`bind.address.service=172.16.0.2` \
`bind.address.management=172.16.0.2` \
`cluster.address=[your external IP / FQDN]` \
**fusion_client_core_sdk_installer-3.3.17.advanced-install.properties** \
`accept.eula=yes` \
`JDKPath=/usr/java/latest` \
`packs=COMMON,GATEWAY,CORE_SDK,MEDIABROKER,SAMPLE_APP` \
`appserver.admin.address=172.16.0.2` \
`gateway.controlled_domain=[your external IP / FQDN]` \
`rtp_proxy_native.tarball.file=/installer/media-broker-native-el7-x86_64-11.tar.gz` \
**cafex_live_assist_installer-1.64.3.production.properties** \
`accept.eula=yes` \
`JDKPath=/usr/java/latest` \
`appserver.admin.address=172.16.0.2` \


4. Make sure you are in the root of your newly created folder. \
The following process should pull down a base image and start the installation of your singlebox solution in a new docker container:
   - To start the image build and installation run: \
`docker-compose up` (It takes 10-15 min to complete - you can watch interactively)
   - Once the FAS and MB services are restarted, press `Ctrl-c` to shut down the container
   - To start the singlebox (running in detached mode) run: \
`docker-compose up -d`		
  - To stop the container run: \
`docker-compose stop`
  - To delete the container and network run: \
`docker-compose down`
  - Delete the `/installer/cbala-install-status` file if you would like to run the installation again before you create a new container