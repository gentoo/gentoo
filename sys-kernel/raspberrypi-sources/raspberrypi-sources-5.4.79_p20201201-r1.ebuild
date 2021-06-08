# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ETYPE=sources
K_DEFCONFIG="bcmrpi_defconfig"
K_SECURITY_UNSUPPORTED=1

inherit kernel-2 eapi7-ver
detect_version

MY_P=$(ver_cut 4-)
MY_P="raspberrypi-kernel_1.${MY_P/p/}-1"

DESCRIPTION="Raspberry Pi kernel sources"
HOMEPAGE="https://github.com/raspberrypi/linux"
SRC_URI="https://github.com/raspberrypi/linux/archive/${MY_P}.tar.gz"

KEYWORDS="~arm ~arm64"

src_unpack() {
	default

	# We want to rename the unpacked directory to a nice normalised string
	# bug #762766
	mv "${WORKDIR}"/linux-${MY_P} "${WORKDIR}"/linux-${KV_FULL} || die
}
