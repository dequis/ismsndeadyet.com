#!/bin/bash
cd "$(dirname "$0")"

regions=(ips_bay ips_bn1 ips_db3)

for i in ${regions[@]}
do
    nmap -n -p 80,443,1863 --min-rtt-timeout 3000ms -iL $i -oX $i.xml > /dev/null
done

(
    for i in $(cat ${regions[@]})
    do
        sh ping-msn.sh $i &
        sleep 0.01
    done
) > ver_results

wait

python2 renderpage.py

cp index.html archive/$(date '+%Y-%m-%d_%H-%M').html
