# ublue-bazzite-custom

This repository is based on the [image-template](https://github.com/ublue-os/image-template), which is the recommended way to make customizations to any image published by the Universal Blue Project.

This specific image is a temporary solution until bazzite-dx catches up with bazzite kernel development.

## Actual State

### Base Image
- `ghcr.io/ublue-os/bazzite:stable`

### Modifications

#### Added Packages (restored deleted packages from the bazzite:43)
- keepassxc (no enable passkey integration with web browsers)
- qemu
- libvirt
- virt-manager
- guestfs-tools
- rocm-hip
- rocm-opencl
- rocm-clinfo
- rocm-smi

#### Removed Packages (please, use the version from homebrew ublue-tap)
- code

## Community

If you have questions, try the following spaces:
- [Universal Blue Forums](https://universal-blue.discourse.group/)
- [Universal Blue Discord](https://discord.gg/WEu6BdFEtp)
- [bootc discussion forums](https://github.com/bootc-dev/bootc/discussions)

## Repository Contents

### Containerfile
The [Containerfile](./Containerfile) defines the operations used to customize the selected image.

### build.sh
The [build.sh](./build_files/build.sh) file is called from your Containerfile. It is where packages are installed and other customizations are made.

### build.yml
The [build.yml](./.github/workflows/build.yml) Github Actions workflow creates the custom OCI image and publishes it to the Github Container Registry (GHCR).

## Justfile Documentation

The `Justfile` contains commands for building and managing container images and virtual machine images.

### Building The Image
`just build`
Builds the container image using Podman.

### Building and Running Virtual Machines and ISOs
`just build-qcow2`
Builds a QCOW2 virtual machine image.

`just build-iso`
Builds an ISO virtual machine image.

`just run-vm-qcow2`
Runs a virtual machine from a QCOW2 image.

## Additional resources

For additional driver support, ublue maintains a set of scripts and container images available at [ublue-akmod](https://github.com/ublue-os/akmods).
