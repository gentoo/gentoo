# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="Library for a virtual ring buffer"
HOMEPAGE="http://vrb.slashusr.org/"
SRC_URI="http://vrb.slashusr.org/download/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="static"
RESTRICT="strip"

DEPEND=""
RDEPEND="
	${DEPEND}
	sys-libs/glibc"

PATCHES=(
	"${FILESDIR}"/${P}-configure.patch
)

DOCS=( README )

src_configure() {
	CC="$(tc-getCC)" ./configure --prefix=/usr || die "Configure failed!"
}

src_install() {
	insinto /usr/include
	doins build/include/vrb.h

	mkdir "${D}"usr/lib || die

	if use static; then
		cp build/lib/libvrb.a* "${D}"usr/lib/ || die
	fi

	cp build/lib/libvrb.so* "${D}"usr/lib/ || die

	dobin build/bin/vbuf
	doman vrb/man/man3/*.3
}
