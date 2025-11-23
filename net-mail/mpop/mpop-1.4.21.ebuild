# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Small, fast, and portable POP3 client"
HOMEPAGE="https://marlam.de/mpop/"
SRC_URI="https://marlam.de/mpop/releases/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gnutls idn keyring nls sasl ssl"
REQUIRED_USE="gnutls? ( ssl )"

RDEPEND="
	idn? ( net-dns/libidn2 )
	keyring? ( app-crypt/libsecret )
	nls? ( virtual/libintl )
	sasl? ( >=net-misc/gsasl-2.1[client] )
	ssl? (
		gnutls? ( >=net-libs/gnutls-3.7.2:=[idn?] )
		!gnutls? (
			dev-libs/openssl:=
		)
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog NEWS NOTES README THANKS )

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		$(use_with ssl tls $(usex gnutls "gnutls" "openssl"))
		$(use_with sasl libgsasl)
		$(use_with idn libidn)
		$(use_with keyring libsecret)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	insinto /usr/share/vim/vimfiles/syntax
	doins scripts/vim/mpop.vim
}
