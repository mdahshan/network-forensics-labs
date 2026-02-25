# Alpine Linux with Fluxbox and network tools
# Build with: docker build -t alpine-pc-fluxbox .

FROM alpine:3.19
LABEL maintainer="Mostafa Dahshan <mdahshan@csu.edu.au>"

RUN apk add --no-cache \
    bash \
    fluxbox \
    font-terminus \
    dbus \
    dbus-x11 \
    mesa-dri-gallium \
    mesa-gl \
    mesa-egl \
    vulkan-loader \
    tigervnc \
    xvfb \
    ttf-freefont \
    ttf-dejavu \
    xterm \
    pcmanfm \
    mc \
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

RUN mkdir /root/.fluxbox
COPY ./menu /root/.fluxbox/
COPY ./chromium-nosandbox.sh /usr/local/bin/chromium-nosandbox
RUN chmod +x /usr/local/bin/chromium-nosandbox

CMD ["sleep", "infinity"]
