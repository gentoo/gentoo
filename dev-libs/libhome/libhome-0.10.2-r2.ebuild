# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools db-use

DESCRIPTION="libhome is a library providing a getpwnam() emulation"
HOMEPAGE="http://pll.sourceforge.net"
SRC_URI="mirror://sourceforge/pll/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="berkdb ldap mysql pam postgres static-libs"

DEPEND="berkdb? ( >=sys-libs/db-4 )
	ldap? ( net-nds/openldap )
	mysql? ( dev-db/mysql-connector-c:= )
	pam? ( virtual/pam )
	postgres? ( dev-db/postgresql[server] )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.10.2-Makefile.patch
	"${FILESDIR}"/${PN}-0.10.2-ldap_deprecated.patch
)

src_prepare() {
	rm -f aclocal.m4

	default

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
		$(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || find "${D}" -name '*.la' -delete
}
