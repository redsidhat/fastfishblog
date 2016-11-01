#!/bin/bash
#getting parameter values and checking them

app=$1
if [ -z $1 ]; then
    echo "App name parameter missing"
    sleep 2
    exit 2
fi

run_env=$2
if [ -z $2 ]; then
    echo "Env name parameter missing"
    sleep 2
    exit 2
fi

server_count=$3
if [ -z $3 ]; then
    echo "Number of server is not specified. Taking deafult 2."
    sleep 1
    server_count=2
fi

server_size=$4
if [ -z $4 ]; then
    echo "Server size is not specified. Taking  t1.micro as deafult "
    sleep 1
    server_size='t1.micro'
fi

