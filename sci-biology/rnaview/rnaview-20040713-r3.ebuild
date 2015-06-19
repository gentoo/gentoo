# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/rnaview/rnaview-20040713-r3.ebuild,v 1.1 2012/08/03 15:04:03 jlec Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Generates 2D displays of RNA/DNA secondary structures with tertiary interactions"
HOMEPAGE="http://ndbserver.rutgers.edu/services/download/index.html"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-makefile.patch \
		"${FILESDIR}"/${P}-implicit.patch
	cat <<- EOF > 22rnaview
		RNAVIEW="${EPREFIX}/usr/share/${PN}"
	EOF
	tc-export CC
}

src_install() {
	default
	doenvd 22rnaview
}
