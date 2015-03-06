#!/bin/sh
# usage: ping-msn.sh <version> <ip>
# prints the IP if the server doesn't support the protocol
# otherwise, quits silently
curl -sk -m10 "https://$2/gateway/gateway.dll?Action=open" -d "VER 1 $1"$'\r\n' | grep -q $1 || echo $2
