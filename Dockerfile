# 使用官方 Golang 1.21 Alpine 基础镜像
FROM golang:1.21 AS builder

# 禁用 CGO
ENV CGO_ENABLED=0

# 设置工作目录
WORKDIR /app

# 复制 go 模块依赖文件
COPY go.mod go.sum ./

# 下载依赖
RUN go mod download

# 复制源代码
COPY . .

# 构建应用（添加更详细的构建参数）
RUN go build -ldflags "-s -w" -o /app/wchatLLM .

# 使用轻量级基础镜像
FROM alpine:latest

# 设置工作目录
WORKDIR /app

# 复制构建的二进制文件
COPY --from=builder /app/wchatLLM /app/wchatLLM

# 暴露端口（根据实际情况调整）
EXPOSE 8080

# 运行应用
CMD ["/app/wchatLLM"]
