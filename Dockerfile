FROM alpine:3

LABEL maintainer="PS <psellars@gmail.com>"

RUN apk add --no-cache \
     --repository=http://dl-cdn.alpinelinux.org/alpine/v3.10/main/ curl=7.66.0-r0 \
     --repository=http://dl-cdn.alpinelinux.org/alpine/v3.10/main/ git=2.26.2-r0 \
     --repository=http://dl-cdn.alpinelinux.org/alpine/v3.10/main/ wget=1.20.3-r1 \
    openssh-client~=8.3_p1 \
    rsync~=3.1.3


ENV VERSION 0.64.0
# RUN mkdir -p /usr/local/src 
WORKDIR /usr/local/src
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN curl -L -o ./hugo.tar.gz \
       https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_${VERSION}_linux-64bit.tar.gz \
    && echo "8797749f92ce7ca8a56523d182ebebaa83e6dbdd  hugo.tar.gz" | sha1sum -c - \
    && tar -xz -f hugo.tar.gz \
    && mv hugo /usr/local/bin/hugo \
    && addgroup -Sg 1000 hugo \
    && adduser -SG hugo -u 1000 -h /src hugo

USER hugo:hugo

WORKDIR /src

EXPOSE 1313

#HEALTHCHECK CMD wget -q --method=HEAD localhost:1313
HEALTHCHECK --interval=10s --timeout=10s --start-period=15s \
  CMD hugo env || exit 1

ENTRYPOINT ["hugo"]
CMD ["serve", "-w", "--bind=0.0.0.0"]

