#!/bin/bash
cd "$(dirname "$0")"

regions=(ips_bay ips_bn2 ips_db5)

for i in ${regions[@]}
do
    nmap -n -p 443 --min-rtt-timeout 3000ms -iL $i -oX $i.xml > /dev/null
done

check_ver() {
    proto=$1
    for ip in $(cat ${regions[@]})
    do
        bash ping-msn.sh $proto $ip &
        sleep 0.05
    done
}

check_ver MSNP21 > ver_results_msnp21 &
wait

python2 renderpage.py

cp index.html archive/$(date '+%Y-%m-%d_%H-%M').html
