# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info linux-mod

DESCRIPTION="r8125 vendor driver for Realtek RTL8125 PCI-E NICs"
HOMEPAGE="https://www.realtek.com/en/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-pci-express-software"

SRC_URI="http://rtitwww.realtek.com/rtdrivers/cn/nic1/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

MODULE_NAMES="r8125(net:${S}/src)"
BUILD_TARGETS="modules"
IUSE="+multi-tx-q ptp +rss use-firmware"

PATCHES=(
	"${FILESDIR}/${PN}-9.011.00-linux-6.1.patch" # bug 890714
	"${FILESDIR}/${PN}-9.011.01-linux-6.2.patch" # bug 908645
)

CONFIG_CHECK="~!R8169"
WARNING_R8169="CONFIG_R8169 is enabled. ${PN} will not be loaded unless kernel driver Realtek 8169 PCI Gigabit Ethernet (CONFIG_R8169) is DISABLED."

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KERNELDIR=${KV_DIR}"
	BUILD_PARAMS+=" ENABLE_PTP_SUPPORT=$(usex ptp y n)"
	BUILD_PARAMS+=" ENABLE_RSS_SUPPORT=$(usex rss y n)"
	BUILD_PARAMS+=" ENABLE_MULTIPLE_TX_QUEUE=$(usex multi-tx-q y n)"
	BUILD_PARAMS+=" ENABLE_USE_FIRMWARE_FILE=$(usex use-firmware y n)"
}

src_install() {
	linux-mod_src_install
	einstalldocs
}
