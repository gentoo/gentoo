# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils flag-o-matic toolchain-funcs

MY_P="${PV/./_}"

DESCRIPTION="Designed to heavily load CPU chips [testing purposes]"
HOMEPAGE="http://pages.sbcglobal.net/redelm/"
#SRC_URI="http://pages.sbcglobal.net/redelm/cpuburn_${MY_P}_tar.gz -> ${P}.tar.gz"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-flags.patch
	use amd64 && append-flags -m32 #65719
	tc-export CC
}

src_install() {
	dodoc Design README
	dobin burn{BX,K6,K7,MMX,P5,P6}
}
