# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

DESCRIPTION="r8168 driver for Realtek 8111/8168 PCI-E NICs"
HOMEPAGE="https://www.realtek.com/en/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-pci-express-software"

SRC_URI="http://rtitwww.realtek.com/rtdrivers/cn/nic1/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

IUSE="use-firmware"

CONFIG_CHECK="~!R8169"
WARNING_R8169="CONFIG_R8169 is enabled. ${P} will not be loaded unless kernel driver Realtek 8169 PCI Gigabit Ethernet (CONFIG_R8169) is DISABLED."

src_compile() {
	local modlist=( ${PN}=kernel/drivers/net/ethernet/realtek:src )
	local modargs=(
		# Build parameters
		KERNELDIR="${KV_OUT_DIR}"
		# Configuration settings
		ENABLE_USE_FIRMWARE_FILE=$(usex use-firmware y n)
	)

	linux-mod-r1_src_compile
}
