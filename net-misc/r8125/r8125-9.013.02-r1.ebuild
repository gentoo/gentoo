# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

DESCRIPTION="r8125 vendor driver for Realtek RTL8125 PCI-E NICs"
HOMEPAGE="https://www.realtek.com/Download/List?cate_id=584"
# Mirrored to avoid captcha
SRC_URI="https://github.com/Karlson2k/r8125/releases/download/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="+multi-tx-q ptp +rss use-firmware"

CONFIG_CHECK="~!R8169"
WARNING_R8169="CONFIG_R8169 is enabled. ${PN} will not be loaded unless kernel driver Realtek 8169 PCI Gigabit Ethernet (CONFIG_R8169) is DISABLED."

src_prepare() {
	default

	# Replace wrong EXTRA_CFLAGS (stopped working with kernels >= 6.15)
	# with proper CFLAGS_MODULE (available since 2.6.36).
	# Bug 957883
	sed -E -i'' \
	  -e 's/(^|[^A-Za-z0-9_])EXTRA_CFLAGS([^A-Za-z0-9_]|$)/\1CFLAGS_MODULE\2/g' \
	  src/Makefile || die
}

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
		ENABLE_PAGE_REUSE=y
		ENABLE_RX_PACKET_FRAGMENT=y
	)

	linux-mod-r1_src_compile
}
