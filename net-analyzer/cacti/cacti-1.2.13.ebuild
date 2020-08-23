# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils webapp

# Support for _p* in version.
MY_P=${P/_p*/}

DESCRIPTION="Cacti is a complete frontend to rrdtool"
HOMEPAGE="https://www.cacti.net/"
SRC_URI="https://www.cacti.net/downloads/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ppc ~ppc64 sparc x86"
IUSE="snmp doc"

need_httpd

RDEPEND="
	dev-lang/php[cli,mysql,pdo,session,sockets,xml]
	dev-php/adodb
	net-analyzer/rrdtool[graph]
	virtual/cron
	snmp? ( >=net-analyzer/net-snmp-5.2.0 )
"

src_compile() { :; }

src_install() {
	dodoc CHANGELOG
	dodoc -r docs
	mv docs .. || die

	webapp_src_preinst

	edos2unix `find -type f -name '*.php'`

	dodir ${MY_HTDOCSDIR}
	cp -r . "${D}"${MY_HTDOCSDIR}

	webapp_serverowned ${MY_HTDOCSDIR}/rra
	webapp_serverowned ${MY_HTDOCSDIR}/log
	webapp_configfile ${MY_HTDOCSDIR}/include/config.php
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt

	webapp_src_install
}
