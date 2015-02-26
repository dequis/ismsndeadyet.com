#!/bin/sh
# usage: ping-msn.sh <version> <ip>
# prints the IP if the server doesn't support the protocol
if [ -z "$(echo VER 1 $1 | nc -w 10 $2 1863 | grep $1)" ]; then
    echo $2
fi
