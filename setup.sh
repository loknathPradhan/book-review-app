#!/bin/bash

# ----------------------------------------
# Kubernetes Dev Environment Setup Script
# ----------------------------------------

set -e  # Exit on any error

echo "🛠️ Starting Kubernetes environment setup..."

# -------------------------
# Install system packages
# -------------------------
echo "📦 Updating packages..."
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y curl wget apt-transport-https ca-certificates gnupg lsb-release bash-completion

# -------------------------
# Install Docker
# -------------------------
echo "🐳 Installing Docker..."

if ! command -v docker &>/dev/null; then
  curl -fsSL https://get.docker.com | sh
  sudo usermod -aG docker $USER
else
  echo "✅ Docker already installed."
fi

# -------------------------
# Install VirtualBox
# -------------------------
echo "📦 Installing VirtualBox..."

if ! command -v vboxmanage &>/dev/null; then
  sudo apt-get install -y virtualbox virtualbox-ext-pack
  sudo usermod -aG vboxusers $USER
else
  echo "✅ VirtualBox already installed."
fi

# -------------------------
# Install kubectl
# -------------------------
echo "🔧 Installing kubectl..."

KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)

curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl

# Bash completion for kubectl
echo 'source <(kubectl completion bash)' >> ~/.bashrc
source ~/.bashrc

# -------------------------
# Install Minikube
# -------------------------
echo "🔧 Installing Minikube..."

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm -f minikube-linux-amd64

# -------------------------
# Show versions
# -------------------------
echo ""
echo "✅ Installation complete."
echo "🔍 Versions:"
docker --version
vboxmanage --version
minikube version
kubectl version --client

echo ""
echo "🚀 To start Minikube (after reboot/log out):"
echo "    minikube start --driver=virtualbox"
echo ""
echo "📢 IMPORTANT: You must log out and log back in for group changes to take effect."

