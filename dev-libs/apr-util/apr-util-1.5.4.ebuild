# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/apr-util/apr-util-1.5.4.ebuild,v 1.10 2015/06/28 18:01:31 zlogene Exp $

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
KEYWORDS="alpha amd64 arm ~arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="berkdb doc freetds gdbm ldap mysql nss odbc openssl postgres sqlite static-libs"
#RESTRICT="test"

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
	>=sys-devel/libtool-2.4.2
	doc? ( app-doc/doxygen )"

DOCS=(CHANGES NOTICE README)

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.5.3-sysroot.patch #385775
	eautoreconf
	elibtoolize
}

src_configure() {
	local myconf=()

	tc-is-static-only && myconf+=( --disable-util-dso )

	if use berkdb; then
		local db_version
		db_version="$(db_findver sys-libs/db)" || die "Unable to find Berkeley DB version"
		db_version="$(db_ver_to_slot "${db_version}")"
		db_version="${db_version/\./}"
		myconf+=(
			--with-dbm=db${db_version}
			# We use $T for the libdir because otherwise it'd simply be the normal
			# system libdir.  That's pointless as the compiler will search it for
			# us already.  This makes cross-compiling and such easier.
			--with-berkeley-db="${SYSROOT}$(db_includedir 2>/dev/null):${T}"
		)
	else
		myconf+=( --without-berkeley-db )
	fi

	if use nss || use openssl ; then
		myconf+=( --with-crypto ) # 518708
	fi

	econf \
		--datadir="${EPREFIX}"/usr/share/apr-util-1 \
		--with-apr="${SYSROOT}${EPREFIX}"/usr \
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
		"${myconf[@]}"
	# Use the current env build settings rather than whatever apr was built with.
	sed -i -r \
		-e "/^(apr_builddir|apr_builders|top_builddir)=/s:=:=${SYSROOT}:" \
		-e "/^CC=/s:=.*:=$(tc-getCC):" \
		-e '/^(C|CPP|CXX|LD)FLAGS=/d' \
		-e '/^LTFLAGS/s:--silent::' \
		build/rules.mk || die
}

src_compile() {
	emake
	use doc && emake dox
}

src_install() {
	default

	find "${ED}" -name "*.la" -delete
	find "${ED}usr/$(get_libdir)/apr-util-${SLOT}" -name "*.a" -delete
	use static-libs || find "${ED}" -name "*.a" -delete

	use doc && dohtml -r docs/dox/html/*

	# This file is only used on AIX systems, which Gentoo is not,
	# and causes collisions between the SLOTs, so remove it.
	rm -f "${ED}usr/$(get_libdir)/aprutil.exp"
}
