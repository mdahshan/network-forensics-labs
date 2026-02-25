# Alpine Linux with xfce4 and network tools
# Build with: docker build -t alpine-pc-xfce4 .

FROM alpine:3.19
LABEL maintainer="Mostafa Dahshan <mdahshan@csu.edu.au>"

RUN apk add --no-cache \
    bash \
    supervisor \
    xfce4 \
    xfce4-terminal \
    xterm \
    sudo \
    dbus \
    dbus-x11 \
    mesa-dri-gallium \
    mesa-gl \
    mesa-egl \
    vulkan-loader \
    ttf-freefont \
    wget \
    curl \
    lftp \
    git \
    openssl \
    openssh \
    mousepad \
    nmap \
    netcat-openbsd \
    bind-tools \
    tcpdump \
    wireshark \
    chromium \
    filezilla

COPY ./chromium-nosandbox.sh /usr/local/bin/chromium-nosandbox
RUN chmod +x /usr/local/bin/chromium-nosandbox

CMD ["sleep", "infinity"]
