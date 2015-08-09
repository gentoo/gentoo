# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit autotools eutils multilib

KEYWORDS="~x86"

DESCRIPTION="Name Service Switch module for use with PostgreSQL"
HOMEPAGE="http://pgfoundry.org/projects/sysauth/"
SRC_URI="http://pgfoundry.org/frs/download.php/605/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="dev-db/postgresql
		app-text/xmlto"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-gentoo.patch"
	epatch "${FILESDIR}/${P}-schema.patch"
	eautoreconf
}

src_compile() {
	econf \
		--libdir=/lib \
		--with-docdir=/usr/share/doc/${PF}/html || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	insinto /$(get_libdir)
	doins src/.libs/libnss_pgsql.so.2.0.0
	dosym libnss_pgsql.so.2.0.0 /lib/libnss_pgsql.so.2
	dosym libnss_pgsql.so.2.0.0 /lib/libnss_pgsql.so

	dodoc AUTHORS ChangeLog NEWS README
	dohtml doc/*.{png,html}
	insinto /usr/share/doc/${PF}/examples
	doins conf/*
}

pkg_postinst() {
	elog "Next steps:"
	elog "1. Create the required tables in the database:"
	elog "   $ psql a_database -f ${ROOT}usr/share/${PN}/conf/dbschema.sql"
	elog "2. Create the configuration file '/etc/nss-pgsql.conf'"
	elog "   You can copy the example from ${ROOT}usr/share/doc/${PF}/examples/nss-pgsql.conf"
	elog "3. Edit /etc/nsswitch.conf to use the NSS service 'pgsql'"
	elog "   An example is available here: ${ROOT}usr/share/doc/${PF}/examples/nsswitch.conf"
}
