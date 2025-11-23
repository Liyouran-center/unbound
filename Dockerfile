# 使用一个轻量级的基础镜像
FROM alpine:3.18

# 安装unbound和unbound-anchor
RUN apk add --no-cache unbound unbound-anchor

# 初始化unbound配置所需的目录和文件
# 使用unbound-anchor工具获取初始的root.key[citation:9]
RUN unbound-anchor -a /var/lib/unbound/root.key || echo "Anchor update attempted, proceeding."

# 确保/var/lib/unbound目录及其内容可由unbound用户写入[citation:10]
RUN chown -R unbound:unbound /var/lib/unbound

# 复制你自己的unbound配置文件
COPY unbound.conf /etc/unbound/unbound.conf

# 检查配置文件语法
RUN unbound-checkconf

# 暴露DNS服务端口
EXPOSE 53/tcp 53/udp

# 以unbound用户身份启动服务
USER unbound
CMD ["unbound", "-d"]
