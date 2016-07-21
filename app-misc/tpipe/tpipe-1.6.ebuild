# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="Command to duplicate standard input to more than one program"
HOMEPAGE="http://www.eurogaran.com/downloads/tpipe"
SRC_URI="http://www.eurogaran.com/downloads/tpipe/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

src_compile() {
	emake OPTFLAGS="-ansi -pedantic ${CFLAGS}" PREFIX=/usr CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" || die
}

src_install() {
	dobin tpipe || die
	doman tpipe.1 || die
	dodoc README.txt || die
}
