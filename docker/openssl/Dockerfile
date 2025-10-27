FROM alpine:3.20
RUN apk add --no-cache openssl bash
WORKDIR /work
COPY generate_certs.sh /work/generate_certs.sh
RUN chmod +x /work/generate_certs.sh
ENTRYPOINT ["/work/generate_certs.sh"]
