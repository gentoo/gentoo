# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ETYPE=sources
K_DEFCONFIG="bcmrpi_defconfig"
K_SECURITY_UNSUPPORTED=1
EXTRAVERSION="-${PN}/-*"
inherit kernel-2
detect_version
detect_arch

inherit git-r3 versionator
EGIT_REPO_URI="https://github.com/raspberrypi/linux.git -> raspberrypi-linux.git"
EGIT_BRANCH="rpi-$(get_version_component_range 1-2).y"
EGIT_CHECKOUT_DIR="${WORKDIR}/linux-${PV}-raspberrypi"
EGIT_CLONE_TYPE="shallow"

DESCRIPTION="Raspberry PI kernel sources"
HOMEPAGE="https://github.com/raspberrypi/linux"

KEYWORDS=""

src_unpack() {
	git-r3_src_unpack
	unpack_set_extraversion
}
