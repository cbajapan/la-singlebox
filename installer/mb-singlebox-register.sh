#!/bin/bash

/opt/fusion/cli/cli.sh <<EOF
$ADMIN_USER
$ADMIN_PASSWORD
update gateway-configuration
update media-brokers $FAS_MASTER_ADDRESS
update webrtc-client-rtp all
update public-local-ports $FAS_MASTER_ADDRESS 16000
set public-address $CLUSTER_ADDRESS
save
save
save
save
exit
EOF