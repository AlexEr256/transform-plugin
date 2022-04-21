FROM kong/go-plugin-tool:latest-alpine-latest AS builder
RUN mkdir -p /tmp/kong-transformer/
COPY ./kong-transformer.go /tmp/kong-transformer/
RUN cd /tmp/kong-transformer/ && \
   go get github.com/Kong/go-pdk && \
   go mod init kong-transformer && \
   go get -d -v github.com/Kong/go-pluginserver && \
   go build github.com/Kong/go-pluginserver && \
   go build -buildmode plugin kong-transformer.go

FROM kong:2.7.1-alpine
RUN mkdir /tmp/go-plugins
COPY --from=builder  /tmp/kong-transformer/go-pluginserver /usr/local/bin/go-pluginserver
COPY --from=builder  /tmp/kong-transformer/kong-transformer.so /tmp/go-plugins
USER root
RUN chmod -R 777 /tmp
RUN /usr/local/bin/go-pluginserver -version && \
   cd /tmp/go-plugins && \
   /usr/local/bin/go-pluginserver -dump-plugin-info kong-transformer
USER kong