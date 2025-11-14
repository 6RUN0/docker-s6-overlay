ARG DEBIAN_VERSION=trixie

FROM debian:${DEBIAN_VERSION}-slim

# s6-overlay build arguments
ARG S6_OVERLAY_VERSION=3.2.1.0
ARG S6_ARCH="x86_64"
# Mirror arguments
ARG DEBIAN_MIRROR="http://mirror.selectel.ru/debian"
ARG DEBIAN_SECURITY_MIRROR="http://mirror.selectel.ru/debian-security"

RUN \
  set -eux; \
  # Configure apt to use a local mirror
  apt_mirror() { \
  sed -i \
  -e "s|http://deb\.debian\.org/debian-security|$3|g" \
  -e "s|http://deb\.debian\.org/debian|$2|g" \
  "$1"; \
  }; \
  [ -w "/etc/apt/sources.list.d/debian.sources" ] && \
  apt_mirror "/etc/apt/sources.list.d/debian.sources" "${DEBIAN_MIRROR}" "${DEBIAN_SECURITY_MIRROR}"; \
  [ -w "/etc/apt/sources.list" ] && \
  apt_mirror "/etc/apt/sources.list" "${DEBIAN_MIRROR}" "${DEBIAN_SECURITY_MIRROR}"; \
  # Install build dependencies
  apt-get update; \
  apt-get full-upgrade -y; \
  saved_apt_mark="$(apt-mark showmanual)"; \
  apt-get install -y --no-install-recommends --no-install-suggests \
  ca-certificates \
  curl \
  xz-utils \
  ; \
  apt-mark auto '.*' > /dev/null; \
  [ -z "$saved_apt_mark" ] || apt-mark manual "$saved_apt_mark" > /dev/null; \
  # Install s6-overlay
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
  # Remove build dependencies and cleanup
  apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
  apt-get autoclean -y; \
  rm -rf \
  "$S6_TEMP_DIR" \
  /var/cache/apt/archives/* \
  /var/lib/apt/lists/* \
  /var/log/alternatives.log \
  /var/log/apt* \
  /var/log/dpkg.log \
  ;

ENTRYPOINT ["/init"]
CMD []
