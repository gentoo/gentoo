# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit versionator

DESCRIPTION="Line and word breaking library"
HOMEPAGE="http://vimgadgets.sourceforge.net/libunibreak/"
SRC_URI="https://github.com/adah1972/${PN}/releases/download/${PN}_$(replace_all_version_separators '_')/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="doc +man static-libs"

DEPEND="man? ( app-doc/doxygen )"
RDEPEND="!dev-libs/liblinebreak"

src_prepare() {
	if use man; then
		echo 'GENERATE_MAN=YES' >> Doxyfile || die
		echo 'GENERATE_HTML=NO' >> Doxyfile || die
	fi
	default
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_compile() {
	default
	if use man; then
		doxygen || die 'doxygen failed'
	fi
}

src_install() {
	use doc && HTML_DOCS=( doc/html/. )
	default
	find "${D}" -name '*.la' -delete || die
	if use man; then
		doman doc/man/man3/*.3
		PREFIX=`echo "${WORKDIR}" | sed -e 's|/|_|g'`
		rm "${D}usr/share/man/man3/${PREFIX}_${P}_src_.3"* || die 'rm man failed'
	fi
}
