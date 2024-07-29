# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Small, fast and conformant XML pull parser written in C"
HOMEPAGE="https://faxpp.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

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
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	find "${ED}" -name '*.la' -delete || die
}
