# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="A small 'net top' tool, grouping bandwidth by process"
HOMEPAGE="http://nethogs.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 x86"

RDEPEND="
	net-libs/libpcap
	sys-libs/ncurses:5=
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=( Changelog DESIGN README )

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	tc-export CC CXX PKG_CONFIG
}
