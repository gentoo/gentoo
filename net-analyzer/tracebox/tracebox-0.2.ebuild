# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="A Middlebox Detection Tool"
HOMEPAGE="http://www.tracebox.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/lua
	net-libs/libcrafter
	net-libs/libpcap
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

RESTRICT="test"

src_prepare() {
	epatch "${FILESDIR}"/${P}-deps.patch

	sed -i -e '/SUBDIRS/s|noinst||g' Makefile.am || die
	sed -i -e '/DIST_SUBDIRS.*libcrafter/d' noinst/Makefile.am || die

	sed -i \
		-e '/[[:graph:]]*libcrafter[[:graph:]]*/d' \
		-e '/dist_bin_SCRIPTS/d' \
		src/${PN}/Makefile.am \
		|| die

	sed -i \
		-e 's|"crafter.h"|<crafter.h>|g' \
		src/${PN}/PacketModification.h \
		src/${PN}/PartialHeader.h \
		src/${PN}/script.h \
		src/${PN}/${PN}.h \
		|| die

	rm README.md || die

	eautoreconf
}
