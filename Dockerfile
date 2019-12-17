FROM golang:1.11-alpine as builder

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
        && apk update \
        && apk add git gcc g++

ADD . /app
WORKDIR /app

RUN GOPROXY="https://goproxy.io" GO111MODULE=on go build -ldflags "-s -w" -o bin/linux/dtunnel_s server.go

FROM alpine
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
        && apk update \
		&& apk add tzdata \
		&& ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
COPY --from=builder /app/bin/linux/dtunnel_s /dtunnel_s
CMD [ "/dtunnel_s" ]

EXPOSE 8000
EXPOSE 8018/udp
