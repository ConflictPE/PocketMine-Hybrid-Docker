FROM ubuntu:17.10

ARG POCKETMINE_GIT_COMMIT="fa6d44ea9e02d4889c8b2e28ea7bc1a2bec83d1d"
ARG POCKETMINE_RAW_GIT_URL="https://raw.githubusercontent.com/pmmp/PocketMine-MP/${POCKETMINE_GIT_COMMIT}"
ARG POCKETMINE_BIN_URL="https://jenkins.pmmp.io/job/PHP-7.2-Aggregate/lastSuccessfulBuild/artifact/PHP-7.2-Linux-x86_64.tar.gz"

RUN groupadd -r pocketmine && useradd -r -g pocketmine pocketmine

# Install the dependencies
RUN \
 apt-get update \
 && apt-get install -y --no-install-recommends \
 apt-transport-https ca-certificates curl software-properties-common git unzip --no-install-recommends \
 && rm -rf /var/lib/apt/lists/*

# Now we setup PocketMine
RUN bash -c "mkdir -p /pocketmine" \
 && cd pocketmine \
 && curl "${POCKETMINE_BIN_URL}" | tar -zx \
 && curl -fsSL "${POCKETMINE_RAW_GIT_URL}/start.sh" -o "start.sh" \
 && curl -fsSL "${POCKETMINE_RAW_GIT_URL}/README.md" -o "README.md" \
 && curl -fsSL "${POCKETMINE_RAW_GIT_URL}/composer.json" -o "composer.json" \
 && curl -fsSL "${POCKETMINE_RAW_GIT_URL}/composer.lock" -o "composer.lock" \
 && chmod +x start.sh \
 && chmod +x ./bin/php7/bin/* \
 && chmod +x ./bin/composer


VOLUME /pocketmine
WORKDIR /pocketmine

EXPOSE 19132 19132/udp

#CMD []