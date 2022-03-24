# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Manage LDAP entries with a text editor"
HOMEPAGE="http://www.lichteblau.com/ldapvi/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
S="${WORKDIR}"/${P}/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~sparc x86"
IUSE="gnutls sasl"

RDEPEND="dev-libs/popt
	dev-libs/glib:2
	net-nds/openldap:=
	sys-libs/readline:=
	sys-libs/ncurses:0=
	virtual/libcrypt:=
	gnutls? ( net-libs/gnutls:= )
	!gnutls? ( dev-libs/openssl:0= )
	sasl? ( dev-libs/cyrus-sasl:2 )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# bug #459478
	sed -i \
		-e '/^AC_SEARCH_LIBS/s:curses ncurses:curses ncurses tinfo:' \
		configure.in || die

	mv configure.{in,ac} || die

	eautoreconf
}

src_configure() {
	econf \
		--with-libcrypto=$(usex gnutls gnutls openssl)
}

src_install() {
	dobin ldapvi
	doman ldapvi.1
	dodoc NEWS manual/{bg.png,html.xsl,manual.{css,xml}}
}
