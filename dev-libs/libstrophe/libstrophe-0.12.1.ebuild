# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A simple, lightweight C library for writing XMPP clients"
HOMEPAGE="http://strophe.im/libstrophe/"
SRC_URI="https://github.com/strophe/${PN}/releases/download/${PV}/${P}.tar.xz"
LICENSE="|| ( MIT GPL-3 )"
# Subslot: ${SONAME}.1 to differentiate from previous versions without SONAME
SLOT="0/0.1"
KEYWORDS="amd64"
IUSE="doc expat gnutls"

RDEPEND="
	expat? ( dev-libs/expat )
	!expat? ( dev-libs/libxml2:2 )
	gnutls? ( net-libs/gnutls:0= )
	!gnutls? ( dev-libs/openssl:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

DOCS=( ChangeLog )

src_configure() {
	# shellcheck disable=SC2207
	local myeconf=(
		--enable-tls
		$(use_with !expat libxml2)
		$(use_with gnutls)
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
	find "${D}" -type f \( -name '*.la' -o -name '*.a' \) -delete || die
}
