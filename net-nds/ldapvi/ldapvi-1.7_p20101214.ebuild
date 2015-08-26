# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

DESCRIPTION="Manage LDAP entries with a text editor"
HOMEPAGE="http://www.lichteblau.com/ldapvi/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="gnutls sasl"

RDEPEND="
	sys-libs/ncurses:0
	net-nds/openldap
	dev-libs/popt
	dev-libs/glib:2
	sys-libs/readline
	gnutls? ( net-libs/gnutls )
	!gnutls? ( dev-libs/openssl:0 )
	sasl? ( dev-libs/cyrus-sasl:2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${P}/${PN}

src_prepare() {
	#bug 459478
	sed -e '/^AC_SEARCH_LIBS/s:curses ncurses:curses ncurses tinfo:' \
		-i configure.in || die
	eautoreconf
}

src_configure() {
	econf --with-libcrypto=$(usex gnutls gnutls openssl)
}

src_install() {
	dobin ldapvi
	doman ldapvi.1
	dodoc NEWS manual/{bg.png,html.xsl,manual.{css,xml}}
}
