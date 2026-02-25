# Alpine Linux with network and security tools
# Build with: docker build -t alpine-netsec .

FROM alpine:3.19
LABEL maintainer="Mostafa Dahshan <mdahshan@csu.edu.au>"

RUN apk add --no-cache \
    bash \
    mc \
    nano \
    wget \
    curl \
    lftp \
    git \
    openssl \
    openssh \
    nmap \
    netcat-openbsd \
    bind-tools \
    tcpdump \
    iperf \
    fping \
    python3 \
    py3-pip

RUN pip3 install --no-cache-dir --break-system-packages scapy

CMD ["sleep", "infinity"]
