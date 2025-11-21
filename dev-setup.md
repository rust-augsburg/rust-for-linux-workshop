# Exercise: Setting Up a Rust-Enabled Linux Kernel Development Environment

## Overview

In this exercise you will:
 * Prepare a Debian VM using QEMU
 * Resize its virtual disk and root filesystem
 * Install toolchains required for Rust-for-Linux
 * Build and boot a kernel with Rust support
 * Load both an in-tree and an out-of-tree Rust kernel module

This environment provides a reproducible setup for all workshop tasks.

Precondition:
`qemu` is installed on your machine.
The exercise has been tested for macOS (Apple Silicon) and Ubuntu 24.04 LTS.


# Setup

## Create Working directory

```sh
mkdir linux-rust-demo
cd linux-rust-demo
```

## Basic setup 

First, choose the appropriate image for your host system. Use the image that matches your host architecture: Ubuntu systems typically run on AMD64, while macOS on Apple Silicon requires an ARM64 image.

```sh
# For Ubuntu: AMD64 image
export VM_IMAGE=debian-13-nocloud-amd64-20251117-2299.qcow2

# For Mac use: ARM64 image
export VM_IMAGE=debian-13-nocloud-arm64-20251117-2299.qcow2
```

Get the image:

```sh
wget "https://cdimage.debian.org/images/cloud/trixie/20251117-2299/${VM_IMAGE}"
```

## (macOS only: Fetch BIOS)

AArch64 uses EF2: cross-platform firmware development environment for the UEFI and PI specifications

```sh
ed2_file=$(find /opt/homebrew/Cellar/qemu -name edk2-aarch64-code.fd)
cp "$ed2_file" ./QEMU_EFI.fd
```


## Resize VM image

Resize the VM Image:

```sh
qemu-img resize "$VM_IMAGE" +32G
```

## Booting the VM


This step is essential and performed frequently, so creating an alias or shell function is highly recommended.

For Ubuntu:

```sh
qemu-system-x86_64 -m 8G -M q35 -accel kvm -smp 8 \
  -hda "${VM_IMAGE}" \
  -device e1000,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp:127.0.0.1:5555-:22 \
  -nographic \
  -serial telnet:localhost:4321,server,wait
```

For macOS:

```sh
qemu-system-aarch64 -m 8G -M virt -cpu host -accel hvf -smp 8 \
  -bios QEMU_EFI.fd \
  -drive if=none,file="${VM_IMAGE}",id=hd0 \
  -device virtio-blk-device,drive=hd0 \
  -device e1000,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp:127.0.0.1:5555-:22 \
  -nographic \
  -serial telnet:localhost:4321,server,wait
```

## Connect to the VM (via telnet)

```sh
telnet localhost 4321
```

user: root, no password

On Mac ensure that telnet is installed: `brew install telnet`

## Resize the root partition

Inside the VM:

```sh
apt update
apt install -y cloud-guest-utils
```

Determine the device name either manually using lsblk or by assigning it as shown below:

```sh
single_disk="/dev/$(lsblk -dn -o NAME | head -n 1)"
echo "$single_disk"
```

This should output something like `/dev/sda`.

Now strech and resize the root partition:

```sh
# Strech the root partition
growpart "$single_disk" 1

# Resize it
resize2fs "$single_disk"1
```

## Setup Kernel Build Tools

A dedicated Rust toolchain (version 1.91.1) is used for reproducibility:

```sh
apt install -y build-essential libssl-dev python3 flex bison bc libncurses-dev gawk openssl libssl-dev libelf-dev libudev-dev libpci-dev libiberty-dev autoconf llvm clang lld git

curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain 1.91.1
source $HOME/.cargo/env

cargo install --locked bindgen-cli
rustup component add rust-src
```

(ATTENTION The commands above install the fixed toolchain version 1.91.1. To install latest Rust toolchain instead, use: `curl https://sh.rustup.rs -sSf | sh -s -- -y`)

## SSH setup

The telnet connection should now be used only for monitoring the system. All actual work such as editing files, cloning repositories, and building should be done over SSH.

```sh
apt install -y openssh-server
nano /etc/ssh/sshd_config
```

WARNING: The following configuration changes significantly weaken SSH security and must never be used in production environments.

Adjust the following settings in `sshd_config`:

```
PermitRootLogin yes
PermitEmptyPasswords yes
```

Restart the SSH service:

```sh
systemctl restart sshd
```

Open a new terminal on the host machine and connect via SSH:

```sh
ssh root@localhost -p 5555
```

# Build the Kernel with Rust support

For this exercise, use the official Rust-for-Linux repository. For complete reproducibility, using a fixed commit hash would be even better, but this example tracks the rust-next branch.

```sh
git clone --depth 1 -b rust-next https://github.com/rust-augsburg/linux
cd linux
```


Ensure that kernel is ready to be built with Rust support:

```sh
make LLVM=1 rustavailable
```

Open the configuration menu and enable the required Rust options:

```sh
make LLVM=1 defconfig 

# menuconfig: Enable Rust support and samples:
# General setup > [*] Rust support
# Kernel hacking > [*] Sample kernel code > [*] Rust samples > Select all
make LLVM=1 menuconfig
```

Now build the kernel, install the modules and the kernel itself:

```sh
make LLVM=1 -j$(nproc)
make LLVM=1 modules_install
make LLVM=1 install
reboot
```

After the reboot, confirm that the new kernel is active:

```sh
uname -r
```

Example output: `6.18.0-rc2-ge5d330e13f67`

ATTENTION: If the system does not boot into the newly built kernel, adjust the GRUB configuration.

To ensure the kernel from `rust-for-linux` is used, configure GRUB to remember and reuse the last selected entry:

```sh
cp /boot/grub/grub.cfg /boot/grub/grub.cfg.bak
# Set GRUB_DEFAULT="saved" and GRUB_SAVEDEFAULT=true in /etc/default/grub
sudo sed -i -e 's/^GRUB_DEFAULT=.*/GRUB_DEFAULT="saved"/' \
            -e 's/^GRUB_SAVEDEFAULT=.*/GRUB_SAVEDEFAULT=true/' /etc/default/grub

# If GRUB_SAVEDEFAULT doesn't exist in the file, append it:
if ! grep -q "^GRUB_SAVEDEFAULT=" /etc/default/grub; then
  echo 'GRUB_SAVEDEFAULT=true' | sudo tee -a /etc/default/grub
fi

# Verify updated settings
cat /boot/grub/grub.cfg

update-grub
reboot
```

During boot, select the newly built kernel in the GRUB menu:

 * Advanced options for Debian GNU/Linux
 * Choose the kernel you just installed

After logging in again, verify the version with uname -r as shown above.

# Test Rust Kernel Module: rust_minimal.ko

In telnet session (if logged in):

```sh
dmesg --follow
```

In the SSH-session:

```sh
cd ~/linux/samples/rust
insmod rust_minimal.ko
rmmod rust_minimal.ko
```

You should now see the corresponding load and unload messages in the kernel log.

# Rust Kernel: Out of tree module

In addition to the in-tree Rust samples provided by the kernel source, you can also build external (out-of-tree) Rust kernel modules. This is a good starting point when developing your own drivers. It allows you to experiment and iterate quickly without modifying the main kernel tree.

```sh
cd ~
git clone https://github.com/rust-augsburg/rust-out-of-tree-module
cd rust-out-of-tree-module
make KDIR=../linux LLVM=1
insmod rust_out_of_tree.ko
```

After loading it, you can check the messages in dmesg to verify that the module initialized correctly.

# Setting up VS Code to work on VM

Install the Remote - SSH extension from the VS Code Marketplace.

On Linux press Ctrl-Shift-X (on macOs: Cmd-Shift-X)
Add the Remote - SSH extension.

To connect from linux, press Ctrl-Shift-P (on macOs: Cmd-Shift-P)

Select Remote-SSH: Connect to Host :  "+ Add New SSH Host:"

Enter: `ssh root@localhost -p 5555`

Confirm and Press Buton Connect

Once connected, you can browse and work with the remote filesystem directly from VS Code.
