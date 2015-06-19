# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/freetds/freetds-0.91-r1.ebuild,v 1.1 2014/01/22 13:37:30 olemarkus Exp $

EAPI=4

inherit autotools eutils

DESCRIPTION="Tabular Datastream Library"
HOMEPAGE="http://www.freetds.org/"
SRC_URI="http://ibiblio.org/pub/Linux/ALPHA/freetds/stable/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~ppc-macos"
IUSE="kerberos odbc iodbc mssql"
RESTRICT="test"

DEPEND="
	iodbc? ( dev-db/libiodbc )
	kerberos? ( virtual/krb5 )
	odbc? ( dev-db/unixODBC )"
RDEPEND="${DEPEND}"

src_prepare() {
	config_rpath_update
	sed -ie 's:with_iodbc/include":with_iodbc/include/iodbc":' configure.ac || die
	epatch ${FILESDIR}/freetds-0.91-fix_field_aliases.patch
	eautoreconf
}

src_configure() {
	local myconf="--with-tdsver=7.0 $(use_enable mssql msdblib)"

	if use iodbc ; then
		myconf="${myconf} --enable-odbc --with-iodbc=${EPREFIX}/usr"
	elif use odbc ; then
		myconf="${myconf} --enable-odbc --with-unixodbc=${EPREFIX}/usr"
	fi
	if use kerberos ; then
		myconf="${myconf} --enable-krb5"
	fi

	econf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" DOCDIR="doc/${PF}" install
}
