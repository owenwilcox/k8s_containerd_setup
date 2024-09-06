#!/bin/bash

FILENAME="containerd-1.7.21-linux-arm64.tar.gz"

wget "https://github.com/containerd/containerd/releases/download/v1.7.21/${FILENAME}"

#code adapted from https://stackoverflow.com/questions/226703/how-do-i-prompt-for-yes-no-cancel-input-in-a-linux-shell-script
while true; do
	read -p "Downloaded file ${FILENAME}. Continue with install?" yn
	case $yn in
		[Yy]*) break;;
		[Nn]*) exit;;
	esac
done


tar Cxzvf /usr/local containerd-1.7.21-linux-arm64.tar.gz

echo "containerd installed. installing systemd service..."

wget "https://raw.githubusercontent.com/containerd/containerd/main/containerd.service"
mkdir -p /usr/local/lib/systemd/system
mv containerd.service /usr/local/lib/systemd/system/containerd.service



systemctl daemon-reload
systemctl enable --now containerd

echo "done, installing runc"

wget "https://github.com/opencontainers/runc/releases/download/v1.1.14/runc.arm64"

install -m 755 runc.arm64 /usr/local/sbin/runc

echo "done, installing CNI plugins..."



wget "https://github.com/containernetworking/plugins/releases/download/v1.5.1/cni-plugins-linux-arm64-v1.5.1.tgz"
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-arm64-v1.5.1.tgz


