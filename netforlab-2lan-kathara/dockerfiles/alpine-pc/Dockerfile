# Alpine Linux  network tools
# Build with: docker build -t alpine-pc .

FROM alpine:3.19
LABEL maintainer="Mostafa Dahshan <mdahshan@csu.edu.au>"

RUN apk add --no-cache \
    bash \
    mc \
    wget \
    curl \
    lftp \
    git \
    openssl \
    openssh \
    nmap \
    netcat-openbsd \
    bind-tools \
    tcpdump

CMD ["sleep", "infinity"]
