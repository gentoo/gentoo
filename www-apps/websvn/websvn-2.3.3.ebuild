# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit depend.php eutils webapp

MY_P="${P//_/}"

DESCRIPTION="Web-based browsing tool for Subversion (SVN) repositories in PHP"
HOMEPAGE="http://www.websvn.info/ http://websvn.tigris.org/"
DOWNLOAD_NUMBER="49056"
SRC_URI="http://websvn.tigris.org/files/documents/1380/${DOWNLOAD_NUMBER}/${MY_P}.tar.gz"

LICENSE="GPL-2"
IUSE="enscript"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

DEPEND=""
RDEPEND="dev-vcs/subversion
	enscript? ( app-text/enscript )"
RESTRICT="mirror"

need_httpd_cgi
need_php_httpd

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	webapp_pkg_setup
	has_php
	require_php_with_use xml
}

src_install() {
	webapp_src_preinst

	mv include/{dist,}config.php

	dodoc changes.txt || die "dodoc failed"
	dohtml doc/* || die "dohtml failed"
	rm -rf license.txt changes.txt doc/

	insinto "${MY_HTDOCSDIR}"
	doins -r . || die "doins failed"

	webapp_configfile "${MY_HTDOCSDIR}"/include/config.php
	webapp_configfile "${MY_HTDOCSDIR}"/wsvn.php

	webapp_serverowned "${MY_HTDOCSDIR}"/cache

	webapp_src_install
}
