# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit webapp

DESCRIPTION="phpSysInfo is a nice package that will display your system stats via PHP"
HOMEPAGE="http://rk4an.github.com/phpsysinfo/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="virtual/httpd-php
	dev-lang/php[simplexml,xml,xsl(+),xslt(+),unicode]"

need_httpd_cgi

S="${WORKDIR}/${PN}"

src_install() {
	webapp_src_preinst

	dodoc ChangeLog README*
	rm ChangeLog COPYING README* || die

	insinto "${MY_HTDOCSDIR}"
	doins -r .
	newins config.php{.new,}

	webapp_configfile "${MY_HTDOCSDIR}"/config.php
	webapp_src_install
}
