# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A simple, lightweight C library for writing XMPP clients"
HOMEPAGE="http://strophe.im/libstrophe/"
SRC_URI="https://github.com/strophe/${PN}/releases/download/${PV}/${P}.tar.gz"
LICENSE="|| ( MIT GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc expat libressl"

RDEPEND="
	expat? ( dev-libs/expat )
	!expat? ( dev-libs/libxml2:2 )
	libressl? ( dev-libs/libressl:0= )
	!libressl? ( dev-libs/openssl:0= )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
"

DOCS=( ChangeLog )
PATCHES=( "${FILESDIR}/libstrophe-0.9.2-libressl.patch" )

src_configure() {
	# shellcheck disable=SC2207
	local myeconf=(
		--enable-tls
		$(use_with !expat libxml2)
	)
	econf "${myeconf[@]}"
}
src_compile() {
	default
	if use doc; then
		doxygen || die
		HTML_DOCS=( docs/html/* )
	fi
}

src_install() {
	default
	use doc && dodoc -r examples
	find "${D}" -name '*.la' -o -name '*.a' -delete || die
}

# Explicit src_test is there to document that the test suite is integrated and
# is expected to pass. Please do not remove.
src_test() {
	emake check
}
