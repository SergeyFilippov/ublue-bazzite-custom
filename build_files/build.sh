#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# remove packages
dnf5 remove -y code || true

# this installs a package from fedora repos
dnf5 install -y keepassxc peazip git git-lfs \
        qemu libvirt virt-manager guestfs-tools \
        podman-compose ffmpeg bc \
        netbird \
        glibc libgcc ca-certificates openssl-libs libstdc++ libicu tzdata krb5-libs zlib dotnet-sdk-10.0 \
        && /ctx/clean.sh

# add required users for virtualization
systemd-sysusers qemu.conf

# enable services
systemctl enable libvirtd
systemctl enable podman.socket

dnf5 -y --setopt=install_weak_deps=False install \
        rocm-smi \
        && /ctx/clean.sh

# Prepa for future upgrades
# dnf5 versionlock add gamescope
