FROM golang:1.21 AS builder

ENV GO111MODULE=on \
    CGO_ENABLED=1 \
    GOOS=linux

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod tidy

RUN go mod download

COPY . .

RUN go build -ldflags "-s -w" -o /app/wchatLLM ./api

FROM alpine

WORKDIR /app

COPY --from=builder /app/wchatLLM /app/wchatLLM

RUN chmod -R 777 /app

EXPOSE 8080

CMD ["/app/wchatLLM"]
