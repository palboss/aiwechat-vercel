# 使用官方Golang基础镜像
FROM golang:1.21-alpine AS builder

# 设置工作目录
WORKDIR /app

# 复制go模块依赖文件
COPY go.mod go.sum ./

# 下载依赖
RUN go mod download

# 复制源代码
COPY . .

# 构建应用
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# 使用轻量级基础镜像
FROM alpine:latest  

WORKDIR /root/

# 复制构建的二进制文件
COPY --from=builder /app/main .

# 暴露端口（根据实际情况调整）
EXPOSE 8080

# 运行应用
CMD ["./main"]
