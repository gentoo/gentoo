# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/phpsysinfo/phpsysinfo-3.1.17.ebuild,v 1.1 2015/01/10 03:00:19 radhermit Exp $

EAPI=5

inherit webapp

DESCRIPTION="phpSysInfo is a nice package that will display your system stats via PHP"
HOMEPAGE="http://rk4an.github.com/phpsysinfo/"
SRC_URI="https://github.com/rk4an/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd"

RDEPEND="virtual/httpd-php
	dev-lang/php[simplexml,xml,xsl(+),xslt(+),unicode]"

need_httpd_cgi

src_install() {
	webapp_src_preinst

	dodoc CHANGELOG.md README*
	rm CHANGELOG.md COPYING README* .gitignore .travis.yml || die

	insinto "${MY_HTDOCSDIR}"
	doins -r .
	newins phpsysinfo.ini{.new,}

	webapp_configfile "${MY_HTDOCSDIR}"/phpsysinfo.ini
	webapp_src_install
}
