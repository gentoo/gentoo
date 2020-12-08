# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ETYPE=sources
K_DEFCONFIG="bcmrpi_defconfig"
K_SECURITY_UNSUPPORTED=1
EXTRAVERSION="-${PN}/-*"

inherit kernel-2 eapi7-ver
detect_version
detect_arch

MY_PV=$(ver_cut 4-)
MY_PV=${MY_PV/p/}
DESCRIPTION="Raspberry Pi kernel sources"
HOMEPAGE="https://github.com/raspberrypi/linux"
SRC_URI="https://github.com/raspberrypi/linux/archive/raspberrypi-kernel_1.${MY_PV}-1.tar.gz"
S="${WORKDIR}/linux-raspberrypi-kernel_1.${MY_PV}-1"

KEYWORDS="~arm ~arm64"

src_unpack() {
	default
}
