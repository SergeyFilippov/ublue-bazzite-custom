#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# remove packages
dnf5 remove -y code

# this installs a package from fedora repos
dnf5 install -y keepassxc

# Prepa for future upgrades
# dnf5 versionlock add gamescope
