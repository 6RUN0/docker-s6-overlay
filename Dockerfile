ARG APLINE_VERSION=latest

FROM alpine:${APLINE_VERSION}

ARG S6_OVERLAY_VERSION=3.2.1.0
ARG TARGETARCH
ARG TARGETVARIANT

RUN \
  set -eux; \
  apk add --no-cache --update --virtual .install-dependencies \
  tar \
  xz \
  ; \
  # Warning! This case not tested with multi-arch build
  # See https://github.com/just-containers/s6-overlay?tab=readme-ov-file#which-architecture-to-use-depending-on-your-targetarch
  case "${TARGETARCH}${TARGETVARIANT:+/${TARGETVARIANT}}" in \
  amd64) S6_ARCH="x86_64" ;; \
  arm64) S6_ARCH="aarch64" ;; \
  arm/v7) S6_ARCH="arm" ;; \
  arm/v6) S6_ARCH="armhf" ;; \
  386) S6_ARCH="i686" ;; \
  riscv64) S6_ARCH="riscv64" ;; \
  s390x) S6_ARCH="s390x" ;; \
  arm) S6_ARCH="armhf" ;; \
  *) echo "Unsupported arch: ${TARGETARCH} ${TARGETVARIANT:-}"; exit 1 ;; \
  esac; \
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
