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
    echo "Tag name is empty, fetching the latest tag..."
    TAG_NAME=$(curl -s https://api.github.com/repos/${GITHUB_REPO}/tags | grep -m 1 '"name"' | grep -oP '(?<="name": ")[^"]*')
    echo "Fetched latest tag: $TAG_NAME"
    if [ -z "$TAG_NAME" ]; then
        echo "No tags found in the repository."
        exit 1
    fi
else
    echo "Using provided tag name: $TAG_NAME"
fi

# Fetch release data for the given tag
RELEASE_DATA=$(curl -s https://api.github.com/repos/${GITHUB_REPO}/releases/tags/${TAG_NAME})

# Check if release data contains the necessary URL
if [ -z "$RELEASE_DATA" ];then
    echo "Release data not found."
    exit 1
fi


# Get the download link for the asset
DOWNLOAD_URL=$(echo "$RELEASE_DATA" | grep -oP '(?<="browser_download_url": ")[^"]*(?=")' | grep "$FILE_NAME")

# Check if the download link exists
if [ -z "$DOWNLOAD_URL" ]; then
    echo "$FILE_NAME not found in the release assets."
    exit 1
fi

# Download the asset
curl -L -o "$FILE_NAME" "$DOWNLOAD_URL"

if [ $? -eq 0 ]; then
    echo "Downloaded $FILE_NAME successfully to $OUTPUT_DIR"
else
    echo "Failed to download $FILE_NAME"
fi
