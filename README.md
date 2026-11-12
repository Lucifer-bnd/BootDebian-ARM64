# BootDebian ARM64

[![Build](https://github.com/Lucifer-bnd/BootDebian-ARM64/actions/workflows/build.yml/badge.svg)](https://github.com/Lucifer-bnd/BootDebian-ARM64/actions/workflows/build.yml)
[![Latest Release](https://img.shields.io/github/v/release/Lucifer-bnd/BootDebian-ARM64)](https://github.com/Lucifer-bnd/BootDebian-ARM64/releases)
[![Downloads](https://img.shields.io/github/downloads/Lucifer-bnd/BootDebian-ARM64/total)](https://github.com/Lucifer-bnd/BootDebian-ARM64/releases)

**BootDebian ARM64** provides a Debian 13 (Trixie) ARM64 command-line environment for rooted Android devices. It installs a Debian root filesystem locally and launches it through `chroot` from a root terminal.

> This project is intended for advanced Android users. It does not provide a graphical desktop environment.

## Features

- Debian GNU/Linux 13 (Trixie), ARM64 / AArch64.
- CLI-only environment; no VNC or desktop components.
- Installable through Magisk or KernelSU Manager.
- No KernelSU Metamodule required.
- Debian root filesystem stored at `/data/local/debian`.
- Root filesystem data is preserved when the module is removed or updated, unless manually deleted.
- Prebuilt root filesystem bundled in the installable module ZIP.

## Requirements

- Android device with 64-bit ARM (AArch64) support.
- Working root access through Magisk or KernelSU.
- Kernel support for `chroot` and the required mount operations.
- Sufficient free storage for the Debian filesystem.
- Network access for installing additional packages inside Debian.

Compatibility depends on the device kernel, root implementation, mount permissions, and SELinux policy.

## Download

Download **`bootdebian-arm64.zip`** from the [GitHub Releases page](https://github.com/Lucifer-bnd/BootDebian-ARM64/releases).

Do not download GitHub's automatically generated source-code archives as a substitute for the installable module ZIP.

## Installation

1. Download `bootdebian-arm64.zip` from Releases.
2. Open Magisk Manager or KernelSU Manager.
3. Choose **Install from storage**.
4. Select the downloaded ZIP.
5. Complete the installation.
6. Open a terminal app and start a root shell:

```sh
su
/data/adb/bootdebian
```

The installer extracts Debian to `/data/local/debian`.

## Usage

Start Debian:

```sh
su
/data/adb/bootdebian
```

Update Debian packages:

```sh
apt update
apt upgrade
```

Install additional packages:

```sh
apt install git curl nano
```

Leave the Debian environment:

```sh
exit
```

## Data and uninstall behavior

- Debian's persistent filesystem is stored in `/data/local/debian`.
- Removing or updating the module is designed not to delete that directory.
- To remove Debian data too, uninstall the module and manually delete `/data/local/debian`.
- Back up important files before modifying or removing the environment.

**Warning:** Deleting `/data/local/debian` permanently removes the installed Debian environment and its data.

## Build from source

GitHub Actions builds the Debian 13 ARM64 root filesystem and packages the module.

1. Fork or clone this repository.
2. Review `config/packages.txt`.
3. Open **Actions → Build BootDebian ARM64**.
4. Run the workflow manually to create a test artifact.
5. Download the artifact from the completed workflow run.

## Publish a GitHub Release

Push a version tag to trigger a tagged build:

```sh
git tag v1.0.0
git push origin v1.0.0
```

When the tagged build succeeds, GitHub Actions publishes a public Release and attaches the installable ZIP and its SHA-256 checksum.

## Project layout

```text
.
├── .github/workflows/
├── config/
├── module/
└── scripts/
```

## Troubleshooting

- **Launcher not found:** run `/data/adb/bootdebian` from a root shell.
- **Not running as root:** execute `su` first.
- **Debian is not installed:** check whether `/data/local/debian/bin/bash` exists.
- **APT cannot resolve hosts:** check the Android device's network and DNS configuration.
- **Mount or chroot errors:** your kernel, root manager, SELinux policy, or mount namespace may restrict the required operations.

When opening an issue, include your device architecture, Android version, root solution, and relevant error output. Never post passwords, access tokens, or other secrets.

## Disclaimer

BootDebian ARM64 is provided **as is**, without warranty. Installing root modules and modifying a rooted Android device can cause data loss, boot problems, or security risks. You are responsible for backing up your data and understanding the commands you run.

Debian is a trademark of Software in the Public Interest, Inc. Android, Magisk, and KernelSU are trademarks or projects of their respective owners. This project is not affiliated with or endorsed by those projects.

## Contributing

Bug reports, tested device compatibility notes, and pull requests are welcome. Please include reproducible steps and relevant logs.

## License

Add a `LICENSE` file before claiming a specific open-source license. Until a license is selected and added, all rights remain with the respective copyright holders.
