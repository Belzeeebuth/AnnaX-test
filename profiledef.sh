#!/usr/bin/env bash

iso_name="annaxiso"
iso_label="ANNAXISO_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="AnnaX Linux <https://github.com/annaxiso>"
iso_application="AnnaX Linux — Arch based distro"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('uefi.systemd-boot')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '15' '-b' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/usr/local/bin/annax"]="0:0:755"
  ["/usr/local/bin/annax-install"]="0:0:755"
  ["/usr/local/bin/annax-welcome"]="0:0:755"
)
