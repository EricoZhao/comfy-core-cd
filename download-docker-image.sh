#!/bin/bash

# 获取最新Release下载链接
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/EricoZhao/comfy-core-cd/releases/latest \
| grep "browser_download_url.*comfyui.tar" \
| cut -d : -f 2,3 \
| tr -d \")

# 下载 Docker 镜像
if [ -n "$DOWNLOAD_URL" ]; then 
  curl -L -o comfyui.tar $DOWNLOAD_URL
  echo "Docker image downloaded successfully."
else
  echo "Failed to find the download URL."
fi
