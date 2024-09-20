# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_P="${P/_/-}"
DESCRIPTION="A portable high-level Jabber/XMPP client library for C++"
HOMEPAGE="https://camaya.net/gloox/"
SRC_URI="https://camaya.net/download/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
# Check upstream changelog: https://camaya.net/gloox/changelog/
SLOT="0/18"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug examples gnutls idn ssl static-libs test +xhtmlim zlib"
RESTRICT="!test? ( test )"

DEPEND="
	idn? ( net-dns/libidn:= )
	gnutls? ( net-libs/gnutls:= )
	ssl? ( dev-libs/openssl:0= )
	zlib? ( sys-libs/zlib )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(usex debug "--enable-debug" '')
		$(use_enable static-libs static)
		$(use_enable xhtmlim)
		$(use_with examples)
		$(use_with gnutls)
		$(use_with idn libidn)
		$(use_with ssl openssl)
		$(use_with test tests)
		$(use_with zlib)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name "*.la" -delete || die

	if use examples; then
		# unhide the libs directory
		mv "${S}"/src/examples/.libs "${S}"/src/examples/libs || die

		dodoc -r src/examples/
	fi
}
