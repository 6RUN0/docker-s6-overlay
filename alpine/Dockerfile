ARG APLINE_VERSION=latest

FROM alpine:${APLINE_VERSION}

ARG S6_OVERLAY_VERSION=3.2.1.0
ARG S6_ARCH="x86_64"

RUN \
  set -eux; \
  apk add --no-cache --update --virtual .install-dependencies \
  tar \
  xz \
  ; \
  S6_BASE_URL="https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}"; \
  S6_TEMP_DIR="$(mktemp -d)"; \
  cd "$S6_TEMP_DIR"; \
  wget -qO "s6-overlay-noarch.tar.xz" "${S6_BASE_URL}/s6-overlay-noarch.tar.xz"; \
  wget -qO "s6-overlay-${S6_ARCH}.tar.xz" "${S6_BASE_URL}/s6-overlay-${S6_ARCH}.tar.xz"; \
  wget -qO "s6-overlay-noarch.tar.xz.sha256" "${S6_BASE_URL}/s6-overlay-noarch.tar.xz.sha256"; \
  wget -qO "s6-overlay-${S6_ARCH}.tar.xz.sha256" "${S6_BASE_URL}/s6-overlay-${S6_ARCH}.tar.xz.sha256"; \
  sha256sum -c "s6-overlay-noarch.tar.xz.sha256"; \
  sha256sum -c "s6-overlay-${S6_ARCH}.tar.xz.sha256"; \
  tar -xJf "s6-overlay-noarch.tar.xz" -C /; \
  tar -xJf "s6-overlay-${S6_ARCH}.tar.xz" -C /; \
  cd /; \
  rm -rf "$S6_TEMP_DIR"; \
  apk del --purge --no-network .install-dependencies;

ENTRYPOINT ["/init"]
CMD []
