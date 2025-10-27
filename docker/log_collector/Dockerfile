FROM alpine:3.20
RUN apk add --no-cache bash
WORKDIR /collector
COPY collector.sh /collector/collector.sh
RUN chmod +x /collector/collector.sh
ENTRYPOINT ["/collector/collector.sh"]
