FROM golang:alpine AS builder
# 为我们的镜像设置必要的环境变量
ENV GO111MODULE=on \
    GOPROXY=https://goproxy.cn,direct \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64
# 移动到工作目录：
WORKDIR /build
# 将代码复制到容器中
COPY ./ go.mod ./
COPY ./go.sum ./
RUN go mod download

COPY . .
RUN go mod tidy
RUN go build -o bluebell .

FROM scratch
# 从builder镜像中把/dist/app 拷贝到当前目录
COPY --from=builder /build/bluebell /
COPY ./conf.yaml /
# 需要运行的命令
ENTRYPOINT ["/bluebell"]
