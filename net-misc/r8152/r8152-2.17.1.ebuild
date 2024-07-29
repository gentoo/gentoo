# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1 udev

DESCRIPTION="r8152 driver for Realtek USB FE / GBE / 2.5G Gaming Ethernet Family Controller"
HOMEPAGE="https://www.realtek.com/en/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-usb-3-0-software"
SRC_URI="http://rtitwww.realtek.com/rtdrivers/cn/nic1/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="virtual/udev"
DEPEND="${RDEPEND}"

IUSE="+center-tap-short"

# https://github.com/wget/realtek-r8152-linux/ keeps reasonably up to date
# with kernel support patches. It appears to be used by the AUR maintainer.
PATCHES=(
	"${FILESDIR}"/${PN}-2.16.3-kernel-6.4.10-fix.patch
	"${FILESDIR}"/${PN}-2.16.3-asus-c5000-support.patch
	"${FILESDIR}"/${PN}-2.17.1-kernel-6.8-strscpy.patch
	"${FILESDIR}"/${PN}-2.17.1-kernel-6.9-fix.patch
)

src_compile() {
	local modlist=( ${PN}=kernel/net/usb:. )
	local modargs=(
		KERNELDIR="${KV_OUT_DIR}"
		CONFIG_CTAP_SHORT="$(usex center-tap-short on off)"
	)

	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install
	udev_dorules 50-usb-realtek-net.rules
}

pkg_postinst() {
	linux-mod-r1_pkg_postinst
	udev_reload
}

pkg_postrm() {
	udev_reload
}
