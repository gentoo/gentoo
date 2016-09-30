# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="A C++ class library for writing CGI applications"
HOMEPAGE="https://www.gnu.org/software/cgicc/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="LGPL-3 doc? ( FDL-1.2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples static-libs"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}/3.2.10-fix-pkgconfig.patch"
	"${FILESDIR}/${PN}-3.2.16-fix-doc-building.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable examples demos) \
		$(use_enable doc) \
		$(use_enable static-libs static)
}

src_install() {
	default

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die

	if use examples; then
		docinto examples
		dodoc {contrib,demo}/{*.{cpp,h},*.cgi,README}
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
