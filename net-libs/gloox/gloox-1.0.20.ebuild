# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${P/_/-}"
DESCRIPTION="A portable high-level Jabber/XMPP library for C++"
HOMEPAGE="https://camaya.net/gloox/"
SRC_URI="https://camaya.net/download/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0/17"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~ia64 ~sparc ~x86"
IUSE="debug gnutls idn libressl ssl static-libs test zlib"

DEPEND="idn? ( net-dns/libidn:= )
	gnutls? ( net-libs/gnutls )
	ssl? (
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl )
	)
	zlib? ( sys-libs/zlib )"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	# Examples are not installed anyway, so - why should we build them?
	econf \
		--without-examples \
		$(usex debug "--enable-debug" '') \
		$(use_enable static-libs static) \
		$(use_with idn libidn) \
		$(use_with gnutls) \
		$(use_with ssl openssl) \
		$(use_with test tests) \
		$(use_with zlib)
}

src_install() {
	default
	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
