# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="Tabular Datastream Library"
HOMEPAGE="http://www.freetds.org/"
SRC_URI="ftp://ftp.freetds.org/pub/freetds/stable/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~ppc-macos"
IUSE="gnutls iconv kerberos libressl mssql iodbc odbc ssl"
RESTRICT="test"

DEPEND="
	gnutls? ( net-libs/gnutls )
	iconv? ( virtual/libiconv )
	iodbc? ( dev-db/libiodbc )
	kerberos? ( virtual/krb5 )
	odbc? ( dev-db/unixODBC )
	ssl? (
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl )
	)"

# bind-tools is needed because the osql script calls "host".
RDEPEND="${DEPEND}
	net-dns/bind-tools
	sys-apps/grep
	sys-apps/sed
	virtual/awk"

src_prepare() {
	default
	# Fix the iodbc include path in the configure script. Otherwise, it
	# can't find isql.h.
	sed -ie 's:with_iodbc/include":with_iodbc/include/iodbc":' \
		configure.ac \
		|| die "failed to fix the iodbc include path in configure.ac"
	eautoreconf
}

src_configure() {
	local myconf=( --with-tdsver=7.4 )

	# The configure script doesn't support --without-{i,unix}odbc and
	# it will still search for the associated headers if you try that
	# Instead, to disable {i,unix}odbc, you just have to omit the
	# --with-{i,unix}odbc line.
	if use iodbc ; then
		myconf+=( --enable-odbc --with-iodbc="${EPREFIX}/usr" )
	fi

	if use odbc ; then
		myconf+=( --enable-odbc --with-unixodbc="${EPREFIX}/usr" )
	fi

	myconf+=( $(use_enable iconv libiconv) )
	use iconv && myconf+=( --with-libiconv-prefix="${EPREFIX}/usr" )
	myconf+=( $(use_enable kerberos krb5) )
	myconf+=( $(use_enable mssql msdblib) )
	myconf+=( $(use_with gnutls) )
	myconf+=( $(use_with ssl openssl "${EPREFIX}/usr") )

	# The docdir doesn't contain ${PV} without this
	myconf+=( --docdir="/usr/share/doc/${PF}" )

	econf "${myconf[@]}"
}
