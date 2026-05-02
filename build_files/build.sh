#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# remove packages
dnf5 remove -y code || true

# this installs a package from fedora repos
dnf5 install -y keepassxc peazip \
        qemu \
        libvirt virt-manager \
        guestfs-tools \
        rocm-hip \
        rocm-opencl \
        rocm-clinfo \
        && /ctx/clean.sh

# add required users for virtualization
systemd-sysusers qemu.conf

# enable services
systemctl enable libvirtd
systemctl enable podman.socket

dnf5 -y --setopt=install_weak_deps=False install \
        rocm-hip \
        rocm-opencl \
        rocm-clinfo \
        rocm-smi \
        && /ctx/clean.sh

# Prepa for future upgrades
# dnf5 versionlock add gamescope
