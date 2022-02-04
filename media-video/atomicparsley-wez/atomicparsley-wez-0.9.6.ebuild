# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

MY_PN=${PN/-wez}

DESCRIPTION="command line program for reading, parsing and setting iTunes-style metadata in MPEG4 files"
HOMEPAGE="https://github.com/wez/atomicparsley"
SRC_URI="https://bitbucket.org/wez/${MY_PN}/get/${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="sys-libs/zlib
	!media-video/atomicparsley"
DEPEND="${RDEPEND}"

DOCS=(Changes.txt CREDITS)

src_unpack() {
	unpack ${A} || die
	mv *-${MY_PN}-* "${S}" || die
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-flags -fno-strict-aliasing
	econf
}
