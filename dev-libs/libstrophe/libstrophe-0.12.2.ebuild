# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A simple, lightweight C library for writing XMPP clients"
HOMEPAGE="https://strophe.im/libstrophe/"
# 2nd SRC is a backport of the /bin/sh -> dash fix, #877049, #879533
SRC_URI="
	https://github.com/strophe/${PN}/releases/download/${PV}/${P}.tar.xz
	https://github.com/strophe/libstrophe/commit/7352bd5cdbacf98771fdc0d32a606c4b6718077c.patch -> ${PN}-fix-configure-bashisms.patch
"
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

PATCHES=(
	# https://github.com/strophe/libstrophe/pull/218
	"${DISTDIR}/${PN}-fix-configure-bashisms.patch"
)

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
