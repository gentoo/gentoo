# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fortran-2

DESCRIPTION="Binary Decision Diagram Package"
HOMEPAGE="https://sourceforge.net/projects/buddy/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="buddy"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc examples"

DOCS=( doc/tech.txt )
PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-gold.patch
)

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die

	if use examples; then
		find examples/ -name 'Makefile*' -delete || die

		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	if use doc; then
		docinto ps
		dodoc doc/*.ps
	fi
}
