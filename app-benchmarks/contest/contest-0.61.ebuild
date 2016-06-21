# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs eutils

DESCRIPTION="Test system responsiveness to compare different kernels"
HOMEPAGE="http://users.tpg.com.au/ckolivas/contest/"
SRC_URI="http://www.tux.org/pub/kernel/people/ck/apps/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=app-benchmarks/dbench-2.0"

src_unpack () {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/contest-fortify_sources.patch"

	#Removing -g
	sed -i "s:-g::" Makefile
	#Adding our cflags
	sed -i "s:-O2:${CFLAGS} ${LDFLAGS}:" Makefile
	sed -i -e "/^CC/s/gcc/$(tc-getCC)/" Makefile
}
src_compile() {
	emake || die
}

src_install() {
	dobin contest || die
	doman contest.1
	dodoc README
}
