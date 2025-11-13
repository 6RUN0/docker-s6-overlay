ARG DEBIAN_VERSION=trixie

FROM debian:${DEBIAN_VERSION}-slim

ARG S6_OVERLAY_VERSION=3.2.1.0
ARG S6_ARCH="x86_64"

RUN \
  set -eux; \
  savedAptMark="$(apt-mark showmanual)"; \
  apt-get update; \
  apt-get install -y --no-install-recommends --no-install-suggests \
  ca-certificates \
  curl \
  xz-utils \
  ; \
  apt-mark auto '.*' > /dev/null; \
  [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark > /dev/null; \
  S6_BASE_URL="https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}"; \
  S6_TEMP_DIR="$(mktemp -d)"; \
  cd "$S6_TEMP_DIR"; \
  curl -fsSL -o "s6-overlay-noarch.tar.xz" "${S6_BASE_URL}/s6-overlay-noarch.tar.xz"; \
  curl -fsSL -o "s6-overlay-${S6_ARCH}.tar.xz" "${S6_BASE_URL}/s6-overlay-${S6_ARCH}.tar.xz"; \
  curl -fsSL -o "s6-overlay-noarch.tar.xz.sha256" "${S6_BASE_URL}/s6-overlay-noarch.tar.xz.sha256"; \
  curl -fsSL -o "s6-overlay-${S6_ARCH}.tar.xz.sha256" "${S6_BASE_URL}/s6-overlay-${S6_ARCH}.tar.xz.sha256"; \
  sha256sum -c "s6-overlay-noarch.tar.xz.sha256"; \
  sha256sum -c "s6-overlay-${S6_ARCH}.tar.xz.sha256"; \
  tar -xJf "s6-overlay-noarch.tar.xz" -C /; \
  tar -xJf "s6-overlay-${S6_ARCH}.tar.xz" -C /; \
  cd /; \
  rm -rf "$S6_TEMP_DIR"; \
  apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
  apt-get autoclean -y; \
  rm -rf \
  /var/cache/apt/archives/* \
  /var/lib/apt/lists/* \
  /var/log/alternatives.log \
  /var/log/apt* \
  /var/log/dpkg.log \
  ;

ENTRYPOINT ["/init"]
CMD []
