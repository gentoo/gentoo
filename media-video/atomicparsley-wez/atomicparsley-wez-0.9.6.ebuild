# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools flag-o-matic

MY_PN=${PN/-wez}

DESCRIPTION="command line program for reading, parsing and setting iTunes-style metadata in MPEG4 files"
HOMEPAGE="https://github.com/wez/atomicparsley"
SRC_URI="https://bitbucket.org/wez/${MY_PN}/get/${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/zlib
	!media-video/atomicparsley"
DEPEND="${RDEPEND}"

DOCS="Changes.txt CREDITS"

src_unpack() {
	unpack ${A}
	mv *-${MY_PN}-* "${S}"
}

src_prepare() {
	eautoreconf
}

src_configure() {
	append-flags -fno-strict-aliasing
	econf
}
