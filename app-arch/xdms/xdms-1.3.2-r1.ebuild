# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="xDMS - Amiga DMS disk image decompressor"
HOMEPAGE="http://zakalwe.fi/~shd/foss/xdms"
SRC_URI="http://zakalwe.fi/~shd/foss/xdms/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE=""

pkg_setup() {
	tc-export CC
}

src_prepare() {
	default
	sed -i Makefile.in \
		-e "s:COPYING::" \
		-e "s:share/doc/xdms-{VERSION}:share/doc/xdms-${PF}:" || die
	sed -i -e "s:-O2::" src/Makefile.in || die
}

src_configure() {
	./configure --prefix=/usr --package-prefix="${D}" || die
}
