# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/rnaview/rnaview-20040713-r2.ebuild,v 1.1 2010/09/06 12:24:45 xarthisius Exp $

EAPI=2

inherit eutils toolchain-funcs

DESCRIPTION="Generates 2D displays of RNA/DNA secondary structures with tertiary interactions"
HOMEPAGE="http://ndbserver.rutgers.edu/services/download/index.html"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="public-domain"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch \
		"${FILESDIR}"/${P}-implicit.patch
	cat <<- EOF > 22rnaview
		RNAVIEW="/usr/share/${PN}"
	EOF
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README || die
	doenvd 22rnaview || die
}
