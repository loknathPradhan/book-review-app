#!/bin/bash

# Exit on any error
set -e

# Colors
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔧 Updating system...${NC}"
sudo apt update

echo -e "${GREEN}📦 Installing Docker...${NC}"
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

echo -e "${GREEN}👤 Adding user to docker group...${NC}"
sudo usermod -aG docker $USER

echo -e "${GREEN}📦 Installing kubectl...${NC}"
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo -e "${GREEN}📦 Installing Minikube...${NC}"
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

echo -e "${GREEN}⚙️ Setting Docker as default Minikube driver...${NC}"
minikube config set driver docker

echo -e "${GREEN}🚀 Starting Minikube with Docker driver...${NC}"
minikube start --driver=docker

echo -e "${GREEN}✅ Minikube setup complete!${NC}"
echo -e "${GREEN}🔁 Please log out and back in or run 'newgrp docker' to apply Docker group changes.${NC}"


# Set root folder name
ROOT_DIR="my-k8s-project"

echo "📁 Creating Kubernetes project structure in '$ROOT_DIR'..."

mkdir -p $ROOT_DIR/{charts,manifests,services/{frontend,user-service,product-service,cart-service,notification-service},infra/{postgres,redis,kafka,minio},observability/{prometheus,grafana,loki},ci-cd/{github-actions,argocd}}

echo "✅ Project directory structure created successfully!"
tree $ROOT_DIR
