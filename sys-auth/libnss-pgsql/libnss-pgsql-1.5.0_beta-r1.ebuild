# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P="${P/_/-}"

DESCRIPTION="Name Service Switch module for use with PostgreSQL"
HOMEPAGE="http://pgfoundry.org/projects/sysauth/"
SRC_URI="http://pgfoundry.org/frs/download.php/1878/${MY_P}.tgz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-db/postgresql:*"
DEPEND="${RDEPEND}
		app-text/xmlto"

src_prepare() {
	eapply "${FILESDIR}/${P}-gentoo.patch"
	eapply_user
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	find "${D}" -name '*.la' -delete || die

	dodoc AUTHORS ChangeLog NEWS README
	docinto examples
	dodoc conf/*
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
