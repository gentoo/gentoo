# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/cone/cone-0.89.ebuild,v 1.4 2012/02/06 17:30:41 ranger Exp $

EAPI=4

inherit eutils autotools

DESCRIPTION="CONE: COnsole News reader and Emailer"
HOMEPAGE="http://www.courier-mta.org/cone/"
SRC_URI="mirror://sourceforge/courier/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="crypt fam gnutls idn ipv6 ldap spell"

RDEPEND=">=dev-libs/openssl-0.9.6
	dev-libs/libxml2
	sys-libs/ncurses
	crypt? ( >=app-crypt/gnupg-1.0.4 )
	fam? ( virtual/fam )
	gnutls? ( net-libs/gnutls )
	idn? ( net-dns/libidn )
	ipv6? ( net-dns/libidn )
	ldap? ( net-nds/openldap )
	spell? ( app-text/aspell )"
DEPEND="${RDEPEND}
	dev-lang/perl"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.84.20100819-aspell-automagic.patch \
		"${FILESDIR}"/${PN}-0.86-skip-rfc2045-test.patch

	cd "${S}"/cone
	LIBTOOLIZE="true" eautoreconf

	cd "${S}"/rfc2045
	eautomake
}

src_configure() {
	local myconf
	if use spell ; then
	   myconf="--with-spellcheck=aspell"
	else
	   myconf="--with-spellcheck=none"
	fi

	econf \
		${myconf} \
		$(use_with ldap ldapaddressbook) \
		$(use_with gnutls) \
		$(use_with idn libidn) \
		$(use_with ipv6)
}

src_install() {
	default
	emake DESTDIR="${D}" install-configure
}
