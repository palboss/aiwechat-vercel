FROM golang:1.23.3-alpine3.20 AS builder
# docker run -dit --name wechat -v C:\Users\zen\Github\aiwechat-vercel:/data golang:1.23.3-alpine3.20 ash
ENV GO111MODULE=on \
    CGO_ENABLED=1 

RUN apk update

RUN apk add build-base

RUN mkdir /data

WORKDIR /data

COPY . .

RUN go mod tidy


RUN go build -ldflags "-s -w" -o /data/wchatLLM ./api

FROM alpine:3.20

RUN mkdir /app
WORKDIR /app

COPY --from=builder /data/wchatLLM /usr/local/bin/wchatLLM

RUN chmod +x /usr/local/bin/wchatLLM

EXPOSE 8080

ENTRYPOINT  ["/usr/local/bin/wchatLLM"]
