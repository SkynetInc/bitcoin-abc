FROM debian:stretch-slim

RUN groupadd -r bitcoin && useradd -r -m -g bitcoin bitcoin

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget libevent-dev libboost-all-dev \
	&& rm -rf /var/lib/apt/lists/*

ENV BITCOIN_VERSION 0.16.2

COPY src/bitcoind /usr/local/bin/bitcoind
COPY src/bitcoin-cli /usr/local/bin/bitcoin-cli
COPY src/bitcoin-seeder /usr/local/bin/bitcoin-seeder
COPY src/bitcoin-tx /usr/local/bin/bitcoin-tx
COPY src/.libs/ /usr/local/lib/


# create data directory
ENV BITCOIN_DATA /data
RUN mkdir "$BITCOIN_DATA" \
	&& chown -R bitcoin:bitcoin "$BITCOIN_DATA" \
	&& ln -sfn "$BITCOIN_DATA" /home/bitcoin/.bitcoin \
	&& chown -h bitcoin:bitcoin /home/bitcoin/.bitcoin
VOLUME /data

# COPY parser /usr/local/bin/parser

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8332 8333 18332 18333
CMD ["bitcoind"]
