# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A simple, lightweight C library for writing XMPP clients"
HOMEPAGE="http://strophe.im/libstrophe"
SRC_URI="https://github.com/strophe/libstrophe/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +expat +ssl"

DEPEND="expat?  ( dev-libs/expat )
	!expat? ( dev-libs/libxml2:2 )
	ssl?    ( dev-libs/openssl:0= )"

RDEPEND="${DEPEND}"
BDEPEND="doc? ( app-doc/doxygen )"

src_configure() {
	econf \
		$(use_enable ssl tls) \
		$(use_with !expat libxml2)
}

src_compile() {
	default

	if use doc ; then
		doxygen || die "Failed to generate docs with Doxygen."
	fi
}

src_install() {
	use doc && local HTML_DOCS=( "${S}"/docs/html/. )
	default
}
