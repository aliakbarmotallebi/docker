#!/bin/bash
set -e

# Remove old versions of Docker
sudo dnf remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine \
                  podman-docker \
                  containerd \
                  runc || true

# Install prerequisites
sudo dnf install -y yum-utils device-mapper-persistent-data lvm2 ca-certificates curl

# Add the official Docker repository
sudo yum-config-manager --add-repo https://mirror.manageit.ir/centos/docker-ce.repo

# Update the package cache
sudo dnf makecache

# Install Docker and plugins
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Create Docker configuration file
sudo mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
  "insecure-registries": ["https://docker.manageit.ir"],
  "registry-mirrors": ["https://docker.manageit.ir"]
}
EOF

# Logout from any previous registry
docker logout

# Start and enable Docker service
sudo systemctl enable --now docker

# Test installation
docker --version
docker compose version

