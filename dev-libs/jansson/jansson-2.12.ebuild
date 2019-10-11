# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="C library for encoding, decoding and manipulating JSON data"
HOMEPAGE="http://www.digip.org/jansson/"
SRC_URI="http://www.digip.org/jansson/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="doc static-libs"

BDEPEND="doc? ( >=dev-python/sphinx-1.0.4 )"
RDEPEND=""

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf $(use_enable static-libs static)
}

multilib_src_compile() {
	default

	if multilib_is_native_abi && use doc ; then
		emake html
		HTML_DOCS=( "${BUILD_DIR}"/doc/_build/html/. )
	fi
}

multilib_src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
