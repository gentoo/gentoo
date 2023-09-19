# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_P="${P/_/-}"
DESCRIPTION="A portable high-level Jabber/XMPP library for C++"
HOMEPAGE="https://camaya.net/gloox/"
SRC_URI="https://camaya.net/download/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
# Check upstream changelog: https://camaya.net/gloox/changelog/
SLOT="0/18"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug gnutls idn ssl static-libs test zlib"
RESTRICT="!test? ( test )"

DEPEND="
	idn? ( net-dns/libidn:= )
	gnutls? ( net-libs/gnutls:= )
	ssl? (
		dev-libs/openssl:0=
	)
	zlib? ( sys-libs/zlib )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.24-musl.patch"
	"${FILESDIR}/${PN}-1.0.24-Makefile.patch"
	"${FILESDIR}/${PN}-1.0.24-slibtool.patch"
	"${FILESDIR}/${PN}-1.0.24-pthread-link.patch"
	"${FILESDIR}/${PN}-1.0.24-bashism-configure.patch"
	"${FILESDIR}/${PN}-1.0.24-fix-gcc12-time.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Examples are not installed anyway, so - why should we build them?
	local myeconfargs=(
		--without-examples
		$(usex debug "--enable-debug" '')
		$(use_enable static-libs static)
		$(use_with idn libidn)
		$(use_with gnutls)
		$(use_with ssl openssl)
		$(use_with test tests)
		$(use_with zlib)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name "*.la" -delete || die
}
