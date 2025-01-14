FROM python:3.12-slim

# 设置工作目录
WORKDIR /comfyui

# 安装 Git 并清理缓存
RUN apt-get update && apt-get install -y git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 下载 ComfyUI 代码
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /comfyui
