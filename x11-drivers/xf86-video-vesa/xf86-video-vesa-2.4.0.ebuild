# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit linux-info xorg-2

DESCRIPTION="Generic VESA video driver"
KEYWORDS="-* alpha amd64 x86"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.6
	>=x11-libs/libpciaccess-0.12.901"
DEPEND="${RDEPEND}"

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
