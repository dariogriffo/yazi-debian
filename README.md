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
(.deb) for [yazi](https://github.com/sxyazi/yazi/) hosted at [debian.griffo.io](https://debian.griffo.io)

Currently supported debian distros are:
- Bookworm
- Trixie
- Sid

This is an unofficial community project to provide a package that's easy to
install on Debian. If you're looking for the yazi source code, see
[yazi](https://github.com/sxyazi/yazi/).

## Install/Update

### The Debian way

```sh
curl -sS https://debian.griffo.io/3B9335DF576D3D58059C6AA50B56A1A69762E9FF.asc | gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/debian.griffo.io.gpg
echo "deb https://debian.griffo.io//apt $(lsb_release -sc 2>/dev/null) main" | sudo tee /etc/apt/sources.list.d/debian.griffo.io.list
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
