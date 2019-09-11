FROM ubuntu:18.04

# ARG S6_OVERLAY_VERSION=v1.17.2.0
ARG S6_OVERLAY_VERSION=v1.22.1.0
ARG DEBIAN_FRONTEND="noninteractive"
ARG PLEX_TOKEN=""
ENV TERM="xterm" LANG="C.UTF-8" LC_ALL="C.UTF-8"

ENTRYPOINT ["/init"]

RUN \
# Update and get dependencies
    apt-get update && \
    apt-get install -y \
      tzdata \
      curl \
      sudo \
      git \
      xmlstarlet \
      wget \
      uuid-runtime \
      unrar \
    && \
# Fetch and extract S6 overlay
    curl -J -L -o /tmp/s6-overlay-amd64.tar.gz https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz && \
    tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && \
# Add user
    useradd -U -d /config -s /bin/false plex && \
    usermod -G users plex && \
# Setup directories
    mkdir -p \
      /config \
      /transcode \
      /storage/videos \
      /storage/tvshows \
      /storage/music \
    && \
# Cleanup
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/*

EXPOSE 32400/tcp 3005/tcp 8324/tcp 32469/tcp 1900/udp 32410/udp 32412/udp 32413/udp 32414/udp
VOLUME /config /transcode /storage/tvshows /storage/movies /storage/music

ENV CHANGE_CONFIG_DIR_OWNERSHIP="true" \
    HOME="/config" \
    PLEX_TOKEN=$PLEX_TOKEN 

ARG TAG=public
ARG URL=

COPY root/ /

# cache bust
ARG CACHEBUST=1

# RUN envsubst < /etc/plexupdate.conf.template > /etc/plexupdate.conf
RUN /opt/plexupdate/plexupdate.sh -a --token=$PLEX_TOKEN
# RUN \
# Save version and install
#    /installBinary.sh

HEALTHCHECK --interval=5s --timeout=2s --retries=20 CMD /healthcheck.sh || exit 1
