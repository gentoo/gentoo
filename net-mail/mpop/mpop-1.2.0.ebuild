# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/mpop/mpop-1.2.0.ebuild,v 1.1 2015/01/04 07:10:55 radhermit Exp $

EAPI=5

DESCRIPTION="A small, fast, and portable POP3 client"
HOMEPAGE="http://mpop.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnutls idn libsecret nls sasl ssl vim-syntax"

RDEPEND="
	idn? ( net-dns/libidn )
	libsecret? ( app-crypt/libsecret )
	nls? ( virtual/libintl )
	sasl? ( virtual/gsasl )
	ssl? (
		gnutls? ( net-libs/gnutls )
		!gnutls? ( dev-libs/openssl )
	)"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

REQUIRED_USE="gnutls? ( ssl )"

DOCS="AUTHORS ChangeLog NEWS NOTES README THANKS"

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with ssl ssl $(usex gnutls "gnutls" "openssl")) \
		$(use_with sasl libgsasl) \
		$(use_with idn libidn) \
		$(use_with libsecret )
}

src_install() {
	default

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/syntax
		doins scripts/vim/mpop.vim
	fi
}
