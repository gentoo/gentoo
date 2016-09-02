# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit fortran-2

DESCRIPTION="Binary Decision Diagram Package"
HOMEPAGE="https://sourceforge.net/projects/buddy/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="buddy"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc examples static-libs"

DOCS=( doc/tech.txt )
PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-gold.patch
)

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	use doc && docinto ps && dodoc doc/*.ps

	if use examples; then
		insinto /usr/share/${PN}/
		doins -r examples
	fi
}
