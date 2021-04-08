# la-singlebox

### You will need:
- Docker installed and running - Windows or Linux
- - (Docker desktop for Mac not working yet!)
- FAS, FCSDK and LA installation zip files from the reseller portal
- Media broker gz file

1. Extract the AS, SDK and Liveassist zip files to their respective directories under /installer
- /fas
- /sdk
- /liveassist

2. Add the media broker .gz file to /installer

3. Edit the .properties fils for each install to suit your environment

4. Make sure you are the root of your newly created folder. The following process should pull down a base image and start the installation of your singlebox solution in a new docker container:
- To start the image build and installation run: 
		docker-compose up (It takes 10-15 min to complete - you can watch interactively)
		
- Once the FAS and MB services are restarted, press Ctrl-c to shut down the container
	
- To start the singlebox (running in detached mode) run:
		docker-compose up -d
		
- To stop the container run:
    docker-compose stop
