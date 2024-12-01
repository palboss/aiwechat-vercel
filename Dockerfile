# 使用官方 Golang 1.21 Alpine 基础镜像
FROM golang:1.21-alpine AS builder

# 设置工作目录
WORKDIR /app

# 安装必要的系统依赖（可选）
RUN apk add --no-cache git gcc musl-dev

# 复制 go 模块依赖文件
COPY go.mod go.sum ./

# 下载依赖
RUN go mod download

# 复制源代码
COPY . .

# 构建应用（添加更详细的构建参数）
RUN go build \
    -ldflags="-w -s" \
    -o main .

# 使用轻量级基础镜像
FROM alpine:latest

# 设置工作目录
WORKDIR /root/

# 复制构建的二进制文件
COPY --from=builder /app/main .

# 暴露端口（根据实际情况调整）
EXPOSE 8080

# 运行应用
CMD ["./main"]
