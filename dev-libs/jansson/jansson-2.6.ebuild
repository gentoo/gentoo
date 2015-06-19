# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/jansson/jansson-2.6.ebuild,v 1.1 2014/03/23 11:46:08 hwoarang Exp $

EAPI="4"
AUTOTOOLS_AUTORECONF=1

inherit autotools-utils

DESCRIPTION="C library for encoding, decoding and manipulating JSON data"
HOMEPAGE="http://www.digip.org/jansson/"
SRC_URI="http://www.digip.org/jansson/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="doc static-libs"

DEPEND="doc? ( >=dev-python/sphinx-1.0.4 )"
RDEPEND=""

DOCS=(CHANGES README.rst)

src_prepare() {
	sed -ie 's/-Werror//' src/Makefile.am || die
	autotools-utils_src_prepare
}

src_compile() {
	autotools-utils_src_compile

	use doc && autotools-utils_src_compile html
}

src_install() {
	use doc && HTML_DOCS=("${AUTOTOOLS_BUILD_DIR}/doc/_build/html/")
	autotools-utils_src_install
}
