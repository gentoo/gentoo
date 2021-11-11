# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info linux-mod

DESCRIPTION="r8168 driver for Realtek 8111/8168 PCI-E NICs"
HOMEPAGE="https://www.realtek.com/en/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-pci-express-software"

# "GBE Ethernet LINUX driver r8168 for kernel up to 5.6" from above link,
# we need to mirror it to avoid users from needing to fill a captcha to
# download
SRC_URI="https://dev.gentoo.org/~pacho/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

MODULE_NAMES="r8168(net:${S}/src)"
BUILD_TARGETS="modules"
IUSE="use-firmware"

CONFIG_CHECK="~!R8169"
WARNING_R8169="CONFIG_R8169 is enabled. ${P} will not be loaded unless kernel driver Realtek 8169 PCI Gigabit Ethernet (CONFIG_R8169) is DISABLED."

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KERNELDIR=${KV_DIR}"
	BUILD_PARAMS+=" ENABLE_USE_FIRMWARE_FILE=$(usex use-firmware y n)"
}

src_install() {
	linux-mod_src_install
	einstalldocs
}
