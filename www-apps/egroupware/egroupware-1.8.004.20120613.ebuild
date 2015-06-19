# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/egroupware/egroupware-1.8.004.20120613.ebuild,v 1.6 2012/10/06 16:55:20 armin76 Exp $

EAPI=4

inherit eutils webapp

MY_PN=eGroupware

DESCRIPTION="Web-based GroupWare suite"
HOMEPAGE="http://www.egroupware.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-${PV}.tar.bz2
	mirror://sourceforge/${PN}/${MY_PN}-egw-pear-${PV}.tar.bz2
	gallery? ( mirror://sourceforge/${PN}/${MY_PN}-gallery-${PV}.tar.bz2 )"

LICENSE="GPL-2"
KEYWORDS="amd64 hppa ppc ~sparc x86"
IUSE="+jpgraph ldap mysql postgres gallery"

# php deps taken from rpm spec
# you can use pdo to access almost anything but sqlite is specifically required
# for the calendar module
# jpgraph is only needed for the projectmanager module
RDEPEND="jpgraph? ( dev-php/jpgraph )
	dev-php/pear
	dev-php/PEAR-Auth_SASL
	virtual/httpd-php
	dev-lang/php[gd,imap,pdo,posix,session,sqlite,ssl,unicode,xml,zip,zlib,ldap?,mysql?,postgres?]
	virtual/cron"

REQUIRED_USE="|| ( mysql postgres )"

need_httpd_cgi

S=${WORKDIR}/${PN}

src_prepare() {
	esvn_clean

	if use jpgraph; then
		einfo "Fixing jpgraph location"
		MY_JPGRAPH_VERSION="$(best_version dev-php/jpgraph)"
		MY_JPGRAPH_VERSION="${MY_JPGRAPH_VERSION/'dev-php/jpgraph-'/}"
		sed -i "s|EGW_SERVER_ROOT . '/../jpgraph/src/jpgraph.php'|'/usr/share/php/jpgraph/jpgraph.php'|" \
			projectmanager/inc/class.projectmanager_ganttchart.inc.php || die "sed jpgraph failed"
		sed -i "s|EGW_SERVER_ROOT . '/../jpgraph/src/jpgraph_gantt.php'|'/usr/share/php/jpgraph/jpgraph_gantt.php'|" \
			projectmanager/inc/class.projectmanager_ganttchart.inc.php || die "sed jpgraph failed"
		sed -i "s|$jpgraph_path .= SEP.'jpgraph';|$jpgraph_path = dirname('/usr/share/php/jpgraph/jpgraph.php');|" \
			setup/check_install.php || die "sed jpgraph failed"
		sed -i "s|'unknown';|'${MY_JPGRAPH_VERSION}';\n         \$available = version_compare(\$version,\$min_version,'>=');|" \
			setup/check_install.php || die "sed jpgraph failed"
	fi
}

src_install() {
	webapp_src_preinst

	dodoc doc/rpm-build/egroupware.cron

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_serverowned "${MY_HTDOCSDIR}/phpgwapi/images"

	webapp_postinst_txt en "${FILESDIR}/postinstall-en-1.2.txt"
	webapp_src_install
}

pkg_postinst() {
	if use ldap; then
		elog "If you are using LDAP contacts/addressbook, please read the upgrade instructions at"
		elog "http://www.egroupware.org/index.php?page_name=wiki&wikipage=ManualSetupUpdate"
		elog "before running the egroupware setup"
	fi

	elog "A cronjob to run eGroupware's async services is available at"
	elog "/usr/share/doc/${P}"

	webapp_pkg_postinst
}
