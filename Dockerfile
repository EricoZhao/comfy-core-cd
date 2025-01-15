FROM python:3.12-slim

# 设置工作目录
WORKDIR /comfyui

# 安装必要的软件包
RUN apt-get update && apt-get install -y git curl jq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 下载并解压最新的Release版本
RUN RELEASE_DATA=$(curl -s https://api.github.com/repos/comfyanonymous/ComfyUI/releases/latest) && \
    RELEASE_URL=$(echo $RELEASE_DATA | jq -r '.tarball_url') && \
    curl -L $RELEASE_URL -o comfyui.tar.gz && \
    mkdir comfyui && \
    tar -xzf comfyui.tar.gz -C comfyui --strip-components=1

# 将要删除的文件和文件夹加载到Dockerfile中
COPY rm_list_in_image.txt .
RUN cat rm_list_in_image.txt | xargs rm -rf

# 删除 rm_list_in_image.txt 文件自身，以便清理镜像
RUN rm -f rm_list_in_image.txt
