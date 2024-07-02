# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Line and word breaking library"
HOMEPAGE="http://vimgadgets.sourceforge.net/libunibreak/"
SRC_URI="https://github.com/adah1972/${PN}/releases/download/${PN}_$(ver_rs 1- '_')/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0/6"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="doc +man static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="man? ( app-text/doxygen )"

src_prepare() {
	default

	if use man; then
		echo 'GENERATE_MAN=YES' >> Doxyfile || die
		echo 'GENERATE_HTML=NO' >> Doxyfile || die
	fi
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_compile() {
	default
	if use man; then
		doxygen || die 'doxygen failed'
		pushd "${S}"/doc/man > /dev/null
		mv man3 x || die
		mkdir man3 || die
		for h in graphemebreak linebreak linebreakdef unibreakbase unibreakdef wordbreak; do
			mv x/${h}.h.3 man3/ || die "man ${h} not found"
		done
		rm -rf x || die
		popd > /dev/null
	fi
}

src_install() {
	use doc && HTML_DOCS=( doc/html/. )
	default
	find "${D}" -name '*.la' -delete || die
	if use man; then
		doman doc/man/man3/*.3
	fi
}
