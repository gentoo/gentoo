# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Generates 2D displays of RNA/DNA secondary structures with tertiary interactions"
HOMEPAGE="http://ndbserver.rutgers.edu/services/download/index.html"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-implicit.patch
)

src_prepare() {
	default
	tc-export CC
}

src_install() {
	default

	cat > 22rnaview <<- EOF || die
		RNAVIEW="${EPREFIX}/usr/share/${PN}"
	EOF
	doenvd 22rnaview
}
