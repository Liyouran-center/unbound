# 使用 Ubuntu 作为基础镜像
FROM ubuntu:22.04

# 设置非交互式前端以避免安装过程中提示
ENV DEBIAN_FRONTEND=noninteractive

# 安装 unbound
RUN apt-get update && \
    apt-get install -y unbound && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 创建必要的目录并设置权限
RUN mkdir -p /var/lib/unbound && \
    chown -R unbound:unbound /var/lib/unbound

# 使用 unbound-anchor 工具获取初始的 root.key
RUN unbound-anchor -a /var/lib/unbound/root.key || echo "Anchor update attempted, proceeding."

# 确保目录权限正确
RUN chown -R unbound:unbound /var/lib/unbound

# 复制 unbound 配置文件
COPY unbound.conf /etc/unbound/unbound.conf

# 检查配置文件语法
RUN unbound-checkconf

# 暴露 DNS 服务端口
EXPOSE 53/tcp 53/udp

# 以 unbound 用户身份启动服务
USER unbound

# 启动 unbound
CMD ["unbound", "-d"]
