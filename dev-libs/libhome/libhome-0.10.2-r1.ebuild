# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools db-use eutils

DESCRIPTION="libhome is a library providing a getpwnam() emulation"
HOMEPAGE="http://pll.sourceforge.net"
SRC_URI="mirror://sourceforge/pll/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="berkdb ldap mysql pam postgres"

DEPEND="berkdb? ( >=sys-libs/db-4 )
	ldap? ( net-nds/openldap )
	mysql? ( virtual/mysql )
	pam? ( virtual/pam )
	postgres? ( dev-db/postgresql[server] )"
RDEPEND="${DEPEND}"

src_prepare() {
	rm -f aclocal.m4

	epatch "${FILESDIR}"/${PN}-0.10.2-Makefile.patch
	epatch "${FILESDIR}"/${PN}-0.10.2-ldap_deprecated.patch

	# bug 225579
	sed -i -e 's:\<VERSION\>:__PKG_VERSION:' configure.in

	sed -i -e '/AC_SEARCH_LIBS.*db4/s: db-4.* db4:'$(db_libname)':' \
		configure.in

	eautoreconf
}

src_configure() {
	econf --without-db3 \
		$(use_with berkdb db4 $(db_includedir)) \
		$(use_with ldap) \
		$(use_with mysql) \
		$(use_with pam) \
		$(use_with postgres pgsql) \
	|| die "econf failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
}
