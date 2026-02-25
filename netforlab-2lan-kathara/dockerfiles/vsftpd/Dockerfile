# FTP Server based on alpine
# Build with: docker build -t vsftpd .

FROM alpine:3.19
LABEL maintainer="Mostafa Dahshan <mdahshan@csu.edu.au>"

RUN apk add --no-cache bash vsftpd

VOLUME ["/etc/vsftpd", "/var/ftp"]

EXPOSE 20 21

CMD ["sleep", "infinity"]
