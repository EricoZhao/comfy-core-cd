# comfy-core-cd
CD for ComfyUI to auto Build and Deploy.

 <br/>  

# How to use
```bash

# step 1: Clone the repository and into
git clone https://github.com/EricoZhao/comfy-core-cd.git
cd comfy-core-cd

# Modify parameters(if need)
- ./download-docker-image.sh -> "TAG_NAME"

# step 2: Grant executable privileges
chmod +x download-docker-image.sh

# step 3: Run the script to download the image
./download-docker-image.sh

# Modify parameters
- ./.env -> "PROJECT_DIR"、"VENV_DIR"
- ./docker-compose.yml -> "ports"

# step 4: Instantiating the image
docker-compose up -d


```
