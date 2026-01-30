FROM ghcr.io/cuhk-haosun/code-docker-base:main

SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

ARG DORADO_VERSION=1.3.1
ARG DORADO_TARBALL="dorado-${DORADO_VERSION}-linux-x64.tar.gz"
ARG DORADO_URL="https://cdn.oxfordnanoportal.com/software/analysis/${DORADO_TARBALL}"

WORKDIR /tmp

# Download + install dorado
RUN wget -nv -O "${DORADO_TARBALL}" "${DORADO_URL}" \
 && tar -xzf "${DORADO_TARBALL}" \
 && rm -f "${DORADO_TARBALL}" \
 && mkdir -p /opt /mnt/model \
 && mv "dorado-${DORADO_VERSION}-linux-x64" /opt/dorado \
 && ln -s /opt/dorado/bin/dorado /usr/local/bin/dorado

ENV PATH="/opt/dorado/bin:${PATH}"

# Cache models in the image (large layer). If you want runtime download instead, remove this.
RUN dorado download --model all --models-directory /mnt/model
