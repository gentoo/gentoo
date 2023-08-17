# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev linux-info linux-mod

DESCRIPTION="r8152 driver for Realtek USB FE / GBE / 2.5G Gaming Ethernet Family Controller"
HOMEPAGE="https://www.realtek.com/en/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-usb-3-0-software"

SRC_URI="http://rtitwww.realtek.com/rtdrivers/cn/nic1/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="virtual/udev"
DEPEND="${RDEPEND}"

MODULE_NAMES="r8152(net/usb:${S})"
BUILD_TARGETS="modules"
IUSE="+center-tap-short"

# https://github.com/wget/realtek-r8152-linux/ keeps reasonably up to date
# with kernel support patches. It appears to be used by the AUR maintainer.
PATCHES=(
	"${FILESDIR}"/${PN}-2.16.3-kernel-5.19-fix.patch
	"${FILESDIR}"/${PN}-2.16.3-kernel-6.1-fix.patch
	"${FILESDIR}"/${PN}-2.16.3-kernel-6.4.10-fix.patch
)

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KERNELDIR=${KV_DIR}"
	BUILD_PARAMS+=" CONFIG_CTAP_SHORT=$(usex center-tap-short on off)"
}

src_install() {
	linux-mod_src_install
	einstalldocs
	udev_dorules 50-usb-realtek-net.rules
}

pkg_postinst() {
	linux-mod_pkg_postinst
	udev_reload
}

pkg_postrm() {
	linux-mod_pkg_postrm
	udev_reload
}
