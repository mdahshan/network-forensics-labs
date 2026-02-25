# Simple DNS server based on dnsmasq
# Build with: docker build -t dnsmasq .

FROM alpine:3.19
LABEL maintainer="Mostafa Dahshan <mdahshan@csu.edu.au>"

RUN apk add --no-cache bash dnsmasq
EXPOSE 53 53/udp

RUN mv /etc/dnsmasq.conf /etc/dnsmasq.conf.bak
COPY dnsmasq.conf /etc/

CMD ["sleep", "infinity"]
