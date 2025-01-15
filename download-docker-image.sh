#!/bin/bash

# Setting parameters
GITHUB_REPO="EricoZhao/comfy-core-cd"
TAG_NAME=""
FILE_NAME="comfyui.tar"
OUTPUT_DIR="./"

# Creating a download directory
mkdir -p $OUTPUT_DIR
cd $OUTPUT_DIR

# Check if TAG_NAME is empty
if [ -z "$TAG_NAME" ]; then
    echo "Tag name is empty, fetching the latest release..."
    RELEASE_DATA=$(curl -s https://api.github.com/repos/${GITHUB_REPO}/releases/latest)
else
    # Get the Release information for a given tag
    RELEASE_DATA=$(curl -s https://api.github.com/repos/${GITHUB_REPO}/releases/tags/${TAG_NAME})
fi

# Check if Release exists
if [ -z "$RELEASE_DATA" ]; then
    echo "Release not found."
    exit 1
fi

# Get the download link
DOWNLOAD_URL=$(echo $RELEASE_DATA | jq -r ".assets[] | select(.name == \"${FILE_NAME}\") | .browser_download_url")

# Check if the download link exists
if [ -z "$DOWNLOAD_URL" ]; then
    echo "${FILE_NAME} not found in the release assets."
    exit 1
fi

# Download image
curl -L -o ${FILE_NAME} ${DOWNLOAD_URL}

if [ $? -eq 0 ]; then
    echo "Downloaded ${FILE_NAME} successfully to ${OUTPUT_DIR}"
else
    echo "Failed to download ${FILE_NAME}"
fi
