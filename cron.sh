#!/bin/bash
cd "$(dirname "$0")"

regions=(ips_bay ips_bn1 ips_db3)

for i in ${regions[@]}
do
    nmap -n -p 80,443,1863 -iL $i -oX $i.xml > /dev/null &
done

(
    for i in $(cat ${regions[@]})
    do
        sh ping-msn.sh $i &
    done
) > ver_results

wait

python2 renderpage.py
