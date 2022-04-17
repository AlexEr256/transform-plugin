FROM kong:latest

USER root
RUN apk update && apk add git unzip luarocks
RUN luarocks install kong-plugin-url-rewrite

USER kong