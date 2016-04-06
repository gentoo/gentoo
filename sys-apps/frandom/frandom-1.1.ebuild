# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit linux-mod udev

DESCRIPTION="Fast kernel-land pseudo-random number generator using the RC4 algorithm"
HOMEPAGE="http://billauer.co.il/frandom.html"
SRC_URI="mirror://sourceforge/project/frandom//${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="strip"

BUILD_TARGETS="default"
BUILD_TARGET_ARCH="${ARCH}"
MODULE_NAMES="frandom(misc)"

src_prepare() {
	sed -i -e "s:\$(shell uname -r):${KV_FULL}:" "${S}"/Makefile || die "sed failed"
}

src_install() {
	linux-mod_src_install

	udev_dorules "${S}"/10-${PN}.rules
}
