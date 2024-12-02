FROM golang:1.21 AS builder

ENV CGO_ENABLED=0

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod tidy

RUN go mod download

COPY . .

RUN go build -ldflags "-s -w" -o /app/wchatLLM ./api

FROM alpine

WORKDIR /app

COPY --from=builder /app/wchatLLM /app/wchatLLM

RUN chmod +x /app/wchatLLM

EXPOSE 8080

CMD ["/app/wchatLLM"]
