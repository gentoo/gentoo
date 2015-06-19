# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/libnss-pgsql/libnss-pgsql-1.5.0_beta.ebuild,v 1.3 2014/12/28 16:55:57 titanofold Exp $

inherit autotools eutils multilib

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Name Service Switch module for use with PostgreSQL"
HOMEPAGE="http://pgfoundry.org/projects/sysauth/"

MY_P="${P/_/-}"
SRC_URI="http://pgfoundry.org/frs/download.php/1878/${MY_P}.tgz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="dev-db/postgresql"
DEPEND="${RDEPEND}
		app-text/xmlto"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-gentoo.patch"
	eautoreconf
}

src_compile() {
	econf \
		--htmldir=/usr/share/doc/${PF}/html || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	find "${D}" -name '*.la' -delete || die

	dodoc AUTHORS ChangeLog NEWS README || die
	insinto /usr/share/doc/${PF}/examples
	doins conf/* || die
}

pkg_postinst() {
	elog "Next steps:"
	elog "1. Create the required tables in the database:"
	elog "   $ psql a_database -f /usr/share/doc/${PF}/examples/dbschema.sql"
	elog "2. Create the configuration file '/etc/nss-pgsql.conf'"
	elog "   You can copy the example from /usr/share/doc/${PF}/examples/nss-pgsql.conf"
	elog "3. Edit /etc/nsswitch.conf to use the NSS service 'pgsql'"
	elog "   An example is available here: /usr/share/doc/${PF}/examples/nsswitch.conf"
}
