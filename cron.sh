#!/bin/bash
cd "$(dirname "$0")"
nmap -p 443,1863 bn1_a bn1_b bay_a bay_b db3_a db3_b -oX scan.xml> /dev/null
python2 renderpage.py
