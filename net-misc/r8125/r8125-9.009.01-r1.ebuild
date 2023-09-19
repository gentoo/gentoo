# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

DESCRIPTION="r8125 vendor driver for Realtek RTL8125 PCI-E NICs"
HOMEPAGE="https://www.realtek.com/en/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-pci-express-software"

SRC_URI="http://rtitwww.realtek.com/rtdrivers/cn/nic1/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+multi-tx-q ptp +rss use-firmware"

PATCHES=(
	"${FILESDIR}/${PN}-9.008.00-linux-5.18.patch" # bug 852311
	"${FILESDIR}/${PN}-9.009.01-linux-5.19.patch"
	"${FILESDIR}/${PN}-9.011.00-linux-6.1.patch" # bug 890714
	"${FILESDIR}/${PN}-9.011.01-linux-6.2.patch" # bug 908645
)

CONFIG_CHECK="~!R8169"
WARNING_R8169="CONFIG_R8169 is enabled. ${PN} will not be loaded unless kernel driver Realtek 8169 PCI Gigabit Ethernet (CONFIG_R8169) is DISABLED."

src_compile() {
	local modlist=( ${PN}=kernel/drivers/net/ethernet/realtek:src )
	local modargs=(
		# Build parameters
		KERNELDIR="${KV_OUT_DIR}"
		# Configuration settings
		ENABLE_PTP_SUPPORT=$(usex ptp y n)
		ENABLE_RSS_SUPPORT=$(usex rss y n)
		ENABLE_MULTIPLE_TX_QUEUE=$(usex multi-tx-q y n)
		ENABLE_USE_FIRMWARE_FILE=$(usex use-firmware y n)
	)

	linux-mod-r1_src_compile
}
