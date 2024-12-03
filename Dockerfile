FROM 1.23.3-alpine3.20 AS builder

ENV GO111MODULE=on \
    CGO_ENABLED=1 \
    GOOS=linux
RUN apk update
WORKDIR /app

COPY . .

RUN go mod tidy

RUN go mod download

COPY . .

RUN go build -ldflags "-s -w" -o /app/wchatLLM ./api

FROM alpine:3.20

WORKDIR /app

COPY --from=builder /app/wchatLLM /usr/local/bin/wchatLLM

RUN chmod +x /app/wchatLLM

EXPOSE 8080

ENTRYPOINT  ["/usr/local/bin/wchatLLM"]
