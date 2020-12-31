# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ETYPE=sources
K_DEFCONFIG="bcmrpi_defconfig"
K_SECURITY_UNSUPPORTED=1
EXTRAVERSION="-${PN}/-*"

inherit kernel-2 eapi7-ver
detect_version
detect_arch

KV_FULL=$(ver_cut 4-)
KV_FULL="raspberrypi-kernel_1.${KV_FULL/p/}-1"
DESCRIPTION="Raspberry Pi kernel sources"
HOMEPAGE="https://github.com/raspberrypi/linux"
SRC_URI="https://github.com/raspberrypi/linux/archive/${KV_FULL}.tar.gz"
S="${WORKDIR}/linux-${KV_FULL}"

KEYWORDS="~arm ~arm64"

src_unpack() {
	default
}
