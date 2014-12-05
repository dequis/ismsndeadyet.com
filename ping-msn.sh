#!/bin/sh
# prints the IP if the server is down
if [ -z "$(echo VER 1 MSNP18 | nc -w 5 $1 1863)" ]; then
    echo $1
fi
