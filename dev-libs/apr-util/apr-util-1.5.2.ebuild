# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/apr-util/apr-util-1.5.2.ebuild,v 1.17 2014/12/28 15:28:44 titanofold Exp $

EAPI="4"

# Usually apr-util has the same PV as apr, but in case of security fixes, this may change.
# APR_PV="${PV}"
APR_PV="1.4.6"

inherit autotools db-use eutils libtool multilib toolchain-funcs

DESCRIPTION="Apache Portable Runtime Utility Library"
HOMEPAGE="http://apr.apache.org/"
SRC_URI="mirror://apache/apr/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="berkdb doc freetds gdbm ldap mysql nss odbc openssl postgres sqlite static-libs"
RESTRICT="test"

RDEPEND="dev-libs/expat
	>=dev-libs/apr-${APR_PV}:1
	berkdb? ( >=sys-libs/db-4 )
	freetds? ( dev-db/freetds )
	gdbm? ( sys-libs/gdbm )
	ldap? ( =net-nds/openldap-2* )
	mysql? ( =virtual/mysql-5* )
	nss? ( dev-libs/nss )
	odbc? ( dev-db/unixODBC )
	openssl? ( dev-libs/openssl )
	postgres? ( dev-db/postgresql )
	sqlite? ( dev-db/sqlite:3 )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

DOCS=(CHANGES NOTICE README)

src_prepare() {
	eautoreconf

	elibtoolize
}

src_configure() {
	local myconf

	tc-is-static-only && myconf+=" --disable-util-dso"

	if use berkdb; then
		local db_version
		db_version="$(db_findver sys-libs/db)" || die "Unable to find Berkeley DB version"
		db_version="$(db_ver_to_slot "${db_version}")"
		db_version="${db_version/\./}"
		myconf+=" --with-dbm=db${db_version} --with-berkeley-db=$(db_includedir 2> /dev/null):${EPREFIX}/usr/$(get_libdir)"
	else
		myconf+=" --without-berkeley-db"
	fi

	econf \
		--datadir="${EPREFIX}"/usr/share/apr-util-1 \
		--with-apr="${EPREFIX}"/usr \
		--with-expat="${EPREFIX}"/usr \
		--without-sqlite2 \
		$(use_with freetds) \
		$(use_with gdbm) \
		$(use_with ldap) \
		$(use_with mysql) \
		$(use_with nss) \
		$(use_with odbc) \
		$(use_with openssl) \
		$(use_with postgres pgsql) \
		$(use_with sqlite sqlite3) \
		${myconf}
}

src_compile() {
	emake CPPFLAGS="${CPPFLAGS}" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"

	if use doc; then
		emake dox
	fi
}

src_install() {
	default

	find "${ED}" -name "*.la" -exec rm -f {} +
	find "${ED}usr/$(get_libdir)/apr-util-${SLOT}" -name "*.a" -exec rm -f {} +

	if use doc; then
		dohtml -r docs/dox/html/*
	fi

	if ! use static-libs; then
		find "${ED}" -name "*.a" -exec rm -f {} +
	fi

	# This file is only used on AIX systems, which Gentoo is not,
	# and causes collisions between the SLOTs, so remove it.
	rm -f "${ED}usr/$(get_libdir)/aprutil.exp"
}
