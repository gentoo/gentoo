# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils webapp

# Support for _p* in version.
MY_P=${P/_p*/}

DESCRIPTION="Cacti is a complete frontend to rrdtool"
HOMEPAGE="http://www.cacti.net/"
SRC_URI="http://www.cacti.net/downloads/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="snmp doc"

need_httpd

RDEPEND="
	dev-lang/php[cli,mysql,session,sockets,xml]
	dev-php/adodb
	net-analyzer/rrdtool[graph]
	virtual/cron
	virtual/mysql
	snmp? ( >=net-analyzer/net-snmp-5.2.0 )
"

src_prepare() {
	default
	sed -i -e \
		's:$config\["library_path"\] . "/adodb/adodb.inc.php":"adodb/adodb.inc.php":' \
		"${S}"/include/global.php || die

	rm -rf lib/adodb || die # don't use bundled adodb
}

src_compile() { :; }

src_install() {
	dodoc docs/{CHANGELOG,txt/manual.txt}
	dodoc -r docs/html/
	rm -rf docs

	webapp_src_preinst

	edos2unix `find -type f -name '*.php'`

	dodir ${MY_HTDOCSDIR}
	cp -r . "${D}"${MY_HTDOCSDIR}

	webapp_serverowned ${MY_HTDOCSDIR}/rra
	webapp_serverowned ${MY_HTDOCSDIR}/log/cacti.log
	webapp_configfile ${MY_HTDOCSDIR}/include/config.php
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt

	webapp_src_install
}
