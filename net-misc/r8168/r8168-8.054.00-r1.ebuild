# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

DESCRIPTION="r8168 driver for Realtek 8111/8168 PCI-E NICs"
HOMEPAGE="https://www.realtek.com/Download/List?cate_id=584"
SRC_URI="https://github.com/mtorromeo/${PN}/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="down-speed-100 +eee hw-acceleration multi-tx-q rss s5-keep-mac +wol-s5 use-firmware +wol"

CONFIG_CHECK="~!R8169"
WARNING_R8169="CONFIG_R8169 is enabled. ${P} will not be loaded unless kernel driver Realtek 8169 PCI Gigabit Ethernet (CONFIG_R8169) is DISABLED."

src_compile() {
	local modlist=( ${PN}=kernel/drivers/net/ethernet/realtek:src )
	local modargs=(
		# Build parameters
		KERNELDIR="${KV_OUT_DIR}"
		# Code build options
		ENABLE_RSS_SUPPORT=$(usex rss y n)
		ENABLE_MULTIPLE_TX_QUEUE=$(usex multi-tx-q y n)
		ENABLE_USE_FIRMWARE_FILE=$(usex use-firmware y n)
		CONFIG_DOWN_SPEED_100=$(usex down-speed-100 y n)
		# Driver defaults
		CONFIG_SOC_LAN=$(usex hw-acceleration y n)
		ENABLE_EEE=$(usex eee y n)
		DISABLE_WOL_SUPPORT=$(usex wol n y)
		ENABLE_S5WOL=$(usex wol-s5 y n)
		ENABLE_S5_KEEP_CURR_MAC=$(usex s5-keep-mac y n)
	)

	linux-mod-r1_src_compile
}
