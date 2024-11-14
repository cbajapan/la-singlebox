#!/bin/bash

/opt/fusion/cli/cli.sh <<EOF
$ADMIN_USER
$ADMIN_PASSWORD
update assist-configuration
set anonymous-agent-access enabled
save
exit
EOF