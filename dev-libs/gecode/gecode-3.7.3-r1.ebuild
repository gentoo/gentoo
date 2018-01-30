# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

DESCRIPTION="An environment for developing constraint-based applications"
SRC_URI="http://www.gecode.org/download/${P}.tar.gz"
HOMEPAGE="http://www.gecode.org/"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		--disable-examples \
		--disable-gist \
		--disable-qt
}

src_compile() {
	default
	use doc && emake doc
}

src_install() {
	default

	if use doc; then
		dohtml -r doc/html/
		einfo "HTML documentation has been installed into " \
			"/usr/share/doc/${PF}/html"
	fi

	if use examples; then
		dodoc -r examples
	fi
}
