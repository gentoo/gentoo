# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

DESCRIPTION="Gecode is an environment for developing constraint-based systems and applications"
SRC_URI="http://www.gecode.org/download/${P}.tar.gz"
HOMEPAGE="http://www.gecode.org/"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples gist"

DEPEND="gist? (
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	media-libs/freetype
	media-libs/libpng
	>=dev-libs/glib-2
)"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		--disable-examples \
		$(use_enable gist qt) \
		$(use_enable gist)
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
		docinto examples
		doins examples/*.cpp
		einfo "Example C++ programs have been installed into " \
			"/usr/share/doc/${PF}/examples"
	fi
}
