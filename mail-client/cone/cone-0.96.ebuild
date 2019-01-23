# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils autotools

DESCRIPTION="CONE: COnsole News reader and Emailer"
HOMEPAGE="https://www.courier-mta.org/cone/"
SRC_URI="mirror://sourceforge/courier/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="crypt fam gnutls idn ipv6 ldap"

RDEPEND=">=dev-libs/openssl-0.9.6:0=
	dev-libs/libxml2
	sys-libs/ncurses:=
	>=net-libs/courier-unicode-2
	app-text/aspell
	crypt? ( >=app-crypt/gnupg-1.0.4 )
	fam? ( virtual/fam )
	gnutls? ( net-libs/gnutls )
	idn? ( net-dns/libidn )
	ipv6? ( net-dns/libidn )
	ldap? ( net-nds/openldap )"
DEPEND="${RDEPEND}
	dev-lang/perl"

src_prepare() {
	default

	# move local macro to m4 and run eautoreconf
	mkdir "${S}/m4"
	sed -n -e '/# AC_PROG_SYSCONFTOOL/,+33 p' "${S}"/aclocal.m4 > \
		m4/sysconftool.m4 || die
	sed -i -e '/^SUBDIRS/i ACLOCAL_AMFLAGS = -I m4' "${S}"/Makefile.am || die

	eautoreconf
}

src_configure() {
	econf \
		--with-spellcheck=aspell \
		$(use_with ldap ldapaddressbook) \
		$(use_with gnutls) \
		$(use_with idn libidn) \
		$(use_with ipv6)
}

src_install() {
	default
	emake DESTDIR="${D}" install-configure
}
