# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

MY_P=${P/_p/-}

DESCRIPTION="CELL spu ps and top alike utilities"
HOMEPAGE="https://sourceforge.net/projects/libspe"
SRC_URI="mirror://sourceforge/libspe/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc ppc64"

RDEPEND="
	sys-libs/ncurses:0=
"
DEPEND="
	${RDEPEND}
	sys-apps/help2man
"

S="${WORKDIR}/${PN}/src"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-buildsystem.patch \
		"${FILESDIR}"/${P}-format-security.patch
	tc-export CC
	append-cppflags -std=gnu89
	export CFLAGS="${CFLAGS}"
	export LDFLAGS="${LDFLAGS}"
	export LIBS="$($(tc-getPKG_CONFIG) --libs ncurses)"
}
