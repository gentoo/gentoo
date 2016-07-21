# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs flag-o-matic

IUSE=""

DESCRIPTION="Tool to compare a burned DVD with an image to check for errors"
HOMEPAGE="http://panteltje.com/panteltje/dvd/"
SRC_URI="http://panteltje.com/panteltje/dvd/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}.diff"
}

src_compile() {
	append-flags -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE	-D_LARGEFILE64_SOURCE
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dobin dvdimagecmp
	dodoc CHANGES README
}
