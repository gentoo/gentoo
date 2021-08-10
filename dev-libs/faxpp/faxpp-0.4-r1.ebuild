# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Small, fast and conformant XML pull parser written in C"
HOMEPAGE="http://faxpp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

src_configure() {
	econf --disable-static
}

src_install() {
	default

	if use doc; then
		docinto html
		dodoc -r docs/api/
	fi
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi

	find "${ED}" -name '*.la' -delete || die
}
