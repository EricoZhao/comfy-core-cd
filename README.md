# comfy-core-cd
CD for ComfyUI to auto Build and Deploy.

 <br/>  

# How to use
```bash

#!/bin/bash

# 克隆仓库
git clone https://github.com/yourusername/comfy-core-cd.git
cd comfy-core-cd

# 获取最新Release下载链接
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/yourusername/comfy-core-cd/releases/latest \
| grep "browser_download_url.*comfyui.tar" \
| cut -d : -f 2,3 \
| tr -d \")

# 下载 Docker 镜像
curl -L -o comfyui.tar $DOWNLOAD_URL

# 加载 Docker 镜像到本地
docker load -i comfyui.tar

```
