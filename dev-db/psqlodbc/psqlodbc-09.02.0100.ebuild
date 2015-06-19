# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/psqlodbc/psqlodbc-09.02.0100.ebuild,v 1.3 2014/12/28 15:15:55 titanofold Exp $

EAPI="4"

inherit multilib versionator

MY_MAJOR=$(get_major_version)
MY_MINOR=$(get_version_component_range 2)
PGSLOT="${MY_MAJOR#0}.${MY_MINOR#0}"

DESCRIPTION="Official ODBC driver for PostgreSQL"
HOMEPAGE="http://www.postgresql.org/"
SRC_URI="mirror://postgresql/odbc/versions/src/${P}.tar.gz"
SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~x86 ~amd64"
IUSE="doc iodbc ssl threads unicode"

DEPEND="dev-db/postgresql:${PGSLOT}
		!iodbc? ( dev-db/unixODBC )
		iodbc? ( dev-db/libiodbc )
		ssl? ( dev-libs/openssl )
"
RDEPEND="${DEPEND}"

src_configure() {
	econf --with-libpq="${EROOT%/}/usr/$(get_libdir)/postgresql-${PGSLOT}/bin/pg_config" \
		$(use_with iodbc) \
		$(use_with !iodbc unixodbc) \
		$(use_enable ssl openssl) \
		$(use_enable threads pthreads) \
		$(use_enable unicode)
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc readme.txt
	use doc && dohtml docs/*
}
