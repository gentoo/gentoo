# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_TARBALL_SUFFIX="xz"
inherit linux-info xorg-3

DESCRIPTION="Generic VESA video driver"
KEYWORDS="-* ~alpha amd64 x86"

pkg_pretend() {
	linux-info_pkg_setup

	if ! linux_config_exists || ! linux_chkconfig_present DEVMEM; then
		echo
		ewarn "This driver requires /dev/mem support in your kernel"
		ewarn "  Device Drivers --->"
		ewarn "    Character devices  --->"
		ewarn "      [*] /dev/mem virtual device support"
		echo
	fi
}
