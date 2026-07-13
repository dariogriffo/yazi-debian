![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/dariogriffo/yazi-debian/total)
![GitHub Downloads (all assets, latest release)](https://img.shields.io/github/downloads/dariogriffo/yazi-debian/latest/total)
![GitHub Release](https://img.shields.io/github/v/release/dariogriffo/yazi-debian)
![GitHub Release Date](https://img.shields.io/github/release-date/dariogriffo/yazi-debian)

<h1>
   <p align="center">
     <a href="https://yazi.org/"><img src="https://github.com/dariogriffo/yazi-debian/blob/main/yazi-logo.png" alt="yazi Logo" width="128" style="margin-right: 20px"></a>
     <a href="https://www.debian.org/"><img src="https://github.com/dariogriffo/yazi-debian/blob/main/debian-logo.png" alt="Debian Logo" width="104" style="margin-left: 20px"></a>
     <br>yazi for Debian
   </p>
</h1>
<p align="center">
 Yazi (means "duck") is a terminal file manager written in Rust, based on non-blocking async I/O. It aims to provide an efficient, user-friendly, and customizable file management experience.
</p>

# yazi for Debian

This repository contains build scripts to produce the _unofficial_ Debian packages
(.deb) for [yazi](https://github.com/sxyazi/yazi/) hosted at [deb.griffo.io](https://deb.griffo.io)

<p align="center">
⭐⭐⭐ Love using yazi on Debian? Show your support by starring this repo or [subscribing](https://buy.stripe.com/aFa28q8hr0lRdlm4a2enS01) — access to this repository requires a yearly subscription. ⭐⭐⭐
</p>

Currently supported debian distros are:
- Bookworm
- Trixie
- Sid

This is an unofficial community project to provide a package that's easy to
install on Debian. If you're looking for the yazi source code, see
[yazi](https://github.com/sxyazi/yazi/).

## Install/Update

📖 **Step-by-step install guide:** [Debian](https://deb.griffo.io/install-latest-yazi-in-debian.html) · [Ubuntu](https://deb.griffo.io/install-latest-yazi-in-ubuntu.html)

### The Debian way

```sh
sudo install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://deb.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc | sudo gpg --dearmor --yes -o /etc/apt/keyrings/deb.griffo.io.gpg
echo "deb [signed-by=/etc/apt/keyrings/deb.griffo.io.gpg] https://deb.griffo.io/apt $(lsb_release -sc 2>/dev/null) main" | sudo tee /etc/apt/sources.list.d/deb.griffo.io.list
sudo apt update
sudo apt install -y yazi
```

### Manual Installation

1. Download the .deb package for your Debian version available on
   the [Releases](https://github.com/dariogriffo/yazi-debian/releases) page.
2. Install the downloaded .deb package.

```sh
sudo dpkg -i <filename>.deb
```
## Updating

To update to a new version, just follow any of the installation methods above. There's no need to uninstall the old version; it will be updated correctly.

## Roadmap

- [x] Produce a .deb package on GitHub Releases
- [x] Set up a debian mirror for easier updates

## Disclaimer

- This repo is not open for issues related to yazi. This repo is only for _unofficial_ Debian packaging.
