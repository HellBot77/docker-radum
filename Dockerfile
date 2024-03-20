FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/doublespeakgames/radum.git && \
    cd radum && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM openjdk:15-slim AS build

WORKDIR /radum
COPY --from=base /git/radum .
RUN apt update && \
    apt download ant && \
    dpkg --force-all --install ant*.deb && \
    ant build

FROM lipanski/docker-static-website

COPY --from=build /radum/build .
