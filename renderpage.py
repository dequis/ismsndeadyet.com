#!/usr/bin/env python2
import os
import xml.etree.ElementTree as ET
from jinja2 import Template

SCAN_XML = 'scan.xml'

def parse(filename):
    tree = ET.parse(filename)
    hostnames = {}
    host_ports = {}

    for host in tree.getroot().findall("host"):
        hostname = host.find("hostnames")[0].attrib['name']
        address = host.find("address").attrib['addr']
        hostnames[hostname] = address
        for port in host.find("ports"):
            portid = int(port.attrib['portid'])
            state = port.find("state").attrib['state'] == 'open'
            host_ports.setdefault(hostname, {})[portid] = state

    output = []
    for hostname, ports in sorted(host_ports.items()):
        output.append((hostname, hostnames[hostname], ports.values()))
    return output

def render(servers):
    template = Template(open("template.html").read().decode("utf-8"))
    output = template.render(servers=servers)
    open("index.html", "w").write(output.encode("utf-8"))

def main():
    render(parse(SCAN_XML))

if __name__ == '__main__':
    main()

