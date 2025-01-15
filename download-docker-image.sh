#!/bin/bash

# 参数设置
GITHUB_REPO="EricoZhao/comfy-core-cd"
TAG_NAME="01-15-25"
FILE_NAME="comfyui.tar"
OUTPUT_DIR="./"

# 创建下载目录
mkdir -p $OUTPUT_DIR
cd $OUTPUT_DIR

# 获取Release信息
RELEASE_DATA=$(curl -s -H "https://api.github.com/repos/${GITHUB_REPO}/releases/tags/${TAG_NAME}")

# 检查Release是否存在
if [ -z "$RELEASE_DATA" ]; then
    echo "Release for tag ${TAG_NAME} not found."
    exit 1
fi

# 获取下载链接
DOWNLOAD_URL=$(echo $RELEASE_DATA | jq -r ".assets[] | select(.name == \"${FILE_NAME}\") | .browser_download_url")

# 检查下载链接是否存在
if [ -z "$DOWNLOAD_URL" ]; then
    echo "${FILE_NAME} not found in the release assets."
    exit 1
fi

# 下载文件
curl -L -o ${FILE_NAME} ${DOWNLOAD_URL}

if [ $? -eq 0 ]; then
    echo "Downloaded ${FILE_NAME} successfully to ${OUTPUT_DIR}"
else
    echo "Failed to download ${FILE_NAME}"
fi
