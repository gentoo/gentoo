# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A small, fast, and portable POP3 client"
HOMEPAGE="https://marlam.de/mpop/"
SRC_URI="https://marlam.de/mpop/releases/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gnutls idn libressl gnome-keyring nls sasl ssl vim-syntax"

RDEPEND="
	idn? ( net-dns/libidn2 )
	gnome-keyring? ( app-crypt/libsecret )
	nls? ( virtual/libintl )
	sasl? ( virtual/gsasl )
	ssl? (
		gnutls? ( net-libs/gnutls:0=[idn?] )
		!gnutls? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:0= )
		)
	)"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

REQUIRED_USE="gnutls? ( ssl )"

DOCS="AUTHORS ChangeLog NEWS NOTES README THANKS"

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with ssl tls $(usex gnutls "gnutls" "openssl")) \
		$(use_with sasl libgsasl) \
		$(use_with idn libidn) \
		$(use_with gnome-keyring libsecret)
}

src_install() {
	default

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/syntax
		doins scripts/vim/mpop.vim
	fi
}
