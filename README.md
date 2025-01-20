# comfy-core-cd
CD for ComfyUI to auto Build and Deploy.

 <br/>  

# How to use

## Usage scenario 01 : Deploy ComfyUI from Docker Hub

```bash
# Make sure you have podman and python installed.

sudo apt-get update
sudo apt-get install -y podman
sudo apt-get install -y python3-pip
pip3 install podman-compose

```

```bash

# step 1: Clone the repository and into
git clone https://github.com/EricoZhao/comfy-core-cd.git
cd comfy-core-cd

# Modify parameters(if need, default is "latest")
- ./download-docker-image.sh -> "TAG_NAME"

# step 2: Grant executable privileges
chmod +x download-docker-image.sh

# step 3: Run the script to download the image
./download-docker-image.sh

# step 4: Load the image into podman
podman load -i ./comfyui.tar

# Modify parameters
- ./.env -> "PROJECT_DIR"、"VENV_DIR"
- ./docker-compose.yml -> "ports"

# step 5: Instantiating the image
podman-compose up -d

```


## Usage scenario 02 : Auto Install ComfyUI with Jupter Notebook



## Usage scenario 03 : Continerized Deployment with Minikube and K3s


```bash
# Host Machine

minikube start --driver=docker --mount --mount-string="D:\DEV\app\comfy-core-cd\comfyui:/mnt/app/comfyui"

# 启用注册表插件
minikube addons enable registry

# 使用 kubectl port-forward 将本地工作站映射到 minikube vm 上的 80 端口
kubectl port-forward --namespace kube-system service/registry 5000:80
# 将发往 docker vm 端口 5000 的流量重定向到主机工作站上的端口 5000
docker run --rm -it --network=host alpine ash -c "apk add socat && socat TCP-LISTEN:5000,reuseaddr,fork TCP:host.docker.internal:5000"

# socat 运行中就可以从本地工作站将图像推送到 minikube 注册表
docker tag comfyui:0.3.10 localhost:5000/comfyui:latest
docker push localhost:5000/comfyui:latest


# logs
kubectl logs comfyui-5ddcb65844-j52hx

# cluster-info
kubectl cluster-info

# kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)


# 验证集群状态
kubectl get nodes

```

```bash
# Work Machine

# 安装 k8s
# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# chmod +x kubectl
# sudo mv ./kubectl /usr/local/bin/kubectl

# 安装 docker.io
# apt-get install -y docker.io

# 安装 k8s 通信组件
# apt-get install -y apt-transport-https ca-certificates software-properties-common

# 下载安装 K3s
curl -L https://github.com/k3s-io/k3s/releases/download/v1.31.4+k3s1/k3s --output /usr/local/bin/k3s
#sudo mv ./k3s /usr/local/bin/k3s
chmod +x /usr/local/bin/k3s

# 启动 K3s Server
# k3s server &

# 安装 K3s Agent
#curl -sfL https://get.k3s.io | K3S_URL=https://<master-ip>:6443 K3S_TOKEN=<your-token> sh -

# 配置K3s节点加入集群
sudo k3s agent --server https://<Minikube主节点IP>:<API_SERVER_端口> --token <your_token>


```