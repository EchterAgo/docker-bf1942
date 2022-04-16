#!/bin/sh

#source /settings.sh

# init env
BFSM=${BFSM:-}

cd /bf1942

if ! [ -z "$BFSM" ]; then
    # start bfsm
    IP=$(hostname -I | awk '{print $1}')
    echo "Starting server on $IP"
    ./bfsmd -ip $IP -port 14667 -nodelay -restart -start -noadmin -daemon
    tail -f bfsmd.log
else
    # start server
    ./bf1942_lnxded +statusMonitor 1
fi
