# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Very versatile TCP pipes"
HOMEPAGE="http://bisqwit.iki.fi/source/pipes.html"
SRC_URI="http://bisqwit.iki.fi/src/arch/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~s390 x86"

src_prepare() {
	# Prevent the build system from looking for dependencies
	touch .depend || die
}

src_compile() {
	emake CC=$(tc-getCC) OPTIM="${CFLAGS}" LDFLAGS="${CFLAGS} ${LDFLAGS}"
}

src_install() {
	dobin plis
	dosym /usr/bin/plis /usr/bin/pcon
	dodoc Examples ChangeLog
	dohtml README.html
}
