FROM python:3.12-slim

# 设置工作目录
WORKDIR /comfyui

# 安装必要的软件包
RUN apt-get update && apt-get install -y git curl sed \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 下载并解压最新的Release版本（无 jq）
RUN RELEASE_DATA=$(curl -s https://api.github.com/repos/comfyanonymous/ComfyUI/releases/latest) && \
    RELEASE_URL=$(echo $RELEASE_DATA | grep -oP '"tarball_url": "\K(.*?)(?=")') && \
    curl -L $RELEASE_URL -o comfyui.tar.gz && \
    mkdir comfyui && \
    tar -xzf comfyui.tar.gz -C comfyui --strip-components=1

# 拷贝并使用 cleanup 来删除指定的文件和文件夹
COPY rm_list_in_image.txt .
RUN cat rm_list_in_image.txt | xargs rm -rf

# 删除 cleanup 文件自身，以便清理镜像
RUN rm -f rm_list_in_image.txt
