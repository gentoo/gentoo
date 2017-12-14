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
	use man && echo -e 'GENERATE_MAN=YES\nGENERATE_HTML=NO' >> Doxyfile
	default
}

src_configure() {
	econf \
		$(use_enable static-libs static)
	use doc && export HTML_DOCS=( doc/html/. )
}

src_compile() {
	default
	use man && doxygen || die
}

src_install() {
	default
	prune_libtool_files
	use man && find "${D}/usr/include" -type f -execdir doman "${S}/doc/man/man3/{}.3" \;
}
