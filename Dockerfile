# 使用轻量级Alpine Linux基础镜像
FROM alpine:3.3

# 安装unbound软件包[citation:4][citation:9]，清理缓存以减小镜像体积
RUN apk add --update unbound && \
    rm -rf /var/cache/apk/*

# 将本地的配置文件复制到镜像中
COPY unbound.conf /etc/unbound/unbound.conf
COPY root.hints /var/unbound/etc/root.hints
COPY root.key /var/unbound/etc/root.key

# 检查配置文件语法是否正确[citation:4][citation:9]
RUN unbound-checkconf

# 设置容器启动时默认执行的命令[citation:4][citation:9]
CMD ["unbound"]
