#!/usr/bin/env python2
import os
import xml.etree.ElementTree as ET
from jinja2 import Template

ver_results = [x.strip() for x in open("ver_results").readlines()]

def parse(region):
    tree = ET.parse("ips_%s.xml" % region)
    host_ports = {}

    for host in tree.getroot().findall("host"):
        hostname = host.find("address").attrib['addr']
        ports = host.find("ports")
        if ports is None:
            host_ports[hostname] = {80: False, 443: False, 1863: False}
        else:
            for port in ports:
                portid = int(port.attrib['portid'])
                state = port.find("state").attrib['state'] == 'open'
                host_ports.setdefault(hostname, {})[portid] = state

    output = []
    for line in open("ips_%s" % region):
        ip = line.strip()
        ver_result = ip not in ver_results
        if ip in host_ports:
            output.append((ip, host_ports[ip].values(), ver_result))

    return (region, output)

def render(regions):
    template = Template(open("template.html").read().decode("utf-8"))
    output = template.render(regions=regions)
    open("index.html", "w").write(output.encode("utf-8"))

def main():
    render([
        parse('bay'),
        parse('bn1'),
        parse('db3'),
    ])

if __name__ == '__main__':
    main()

