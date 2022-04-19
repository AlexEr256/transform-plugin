FROM kong/go-plugin-tool:latest-alpine-latest AS builder
RUN mkdir -p /tmp/go-plugins/
COPY ./kong-transformer.go /tmp/go-plugins/
RUN cd /tmp/go-plugins/ && \
   go get github.com/Kong/go-pdk && \
   go mod init kong-go-plugin && \
   go get -d -v github.com/Kong/go-pluginserver && \
   go build github.com/Kong/go-pluginserver && \
   go build -buildmode plugin kong-transformer.go

FROM kong:2.7.1-alpine
RUN mkdir /tmp/go-plugins
COPY --from=builder  /tmp/go-plugins/go-pluginserver /usr/local/bin/go-pluginserver
COPY --from=builder  /tmp/go-plugins/kong-transformer.so /tmp/go-plugins
USER root
RUN chmod -R 777 /tmp
RUN /usr/local/bin/go-pluginserver -version && \
   cd /tmp/go-plugins && \
   /usr/local/bin/go-pluginserver -dump-plugin-info kong-transformer
USER kong