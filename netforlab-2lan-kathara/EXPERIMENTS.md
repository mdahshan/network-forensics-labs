# Netfor Forensics Experiments

This guide provides short, repeatable activities for classroom labs.

## 1) ARP + ICMP Path Observation

- On `pc1`: `tcpdump -n -i eth0`
- From `pc1`: `ping -c 4 web1`
- From `pc1`: `ping -c 4 web2`

What to observe:
- ARP requests/replies before first packet exchange.
- TTL differences for same-LAN vs routed traffic.
- Router hop behavior between LAN A and LAN B.

## 2) DNS Query Inspection

- On `wiresharka`, filter: `dns`
- From `pc2`:
  - `nslookup web1.netforlab.net`
  - `nslookup web2.netforlab.net`

What to observe:
- Query type (`A`, `AAAA`) and response sections.
- Resolution latency and retry behavior.

## 3) HTTP Traffic Walkthrough

- On `wiresharka`, filter: `http or tcp.port == 80`
- From `pc2` browser, visit `http://web1.netforlab.net`
- Repeat for `http://web2.netforlab.net`

What to observe:
- TCP handshake sequence.
- HTTP request/response headers.
- Object retrieval pattern (HTML, CSS, images).

## 4) FTP Session Analysis

- On `wiresharka`, filter: `ftp or ftp-data`
- Connect to `ftp1.netforlab.net` with user/password `ftpuser`.
- Upload and download sample files.

What to observe:
- Control channel commands (`USER`, `PASS`, `LIST`, `RETR`, `STOR`).
- Data channel setup and transfer timing.

## 5) Suspicious Traffic Simulation

- On `nspc1` or `nspc2`, run:

  - `python3 /root/scripts/syn_flood.py <target_ip> --port 80 --count 30`

- Capture on the corresponding Wireshark node.

What to observe:
- Burst patterns and repeated destinations.
- Distinguish normal service traffic from scripted anomalous activity.

Prerequisites:
- Python 3 and Scapy (already included in `netfor-alpine-netsec`).

## Suggested Deliverables (Students)

- A packet capture (`.pcapng`) for each exercise.
- A short timeline of events (timestamp, source, destination, protocol).
- A one-page summary of findings and indicators.
