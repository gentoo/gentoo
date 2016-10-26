# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit webapp

MY_P="${P//_/}"

DESCRIPTION="Web-based browsing tool for Subversion (SVN) repositories in PHP"
HOMEPAGE="http://www.websvn.info/ http://websvn.tigris.org/"
DOWNLOAD_NUMBER="49056"
SRC_URI="http://websvn.tigris.org/files/documents/1380/${DOWNLOAD_NUMBER}/${MY_P}.tar.gz"

LICENSE="GPL-2"
IUSE="enscript"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86"

DEPEND=""
RDEPEND="dev-lang/php:*[xml]
	dev-vcs/subversion
	virtual/httpd-php:*
	enscript? ( app-text/enscript )"
RESTRICT="mirror"

PATCHES=(
	"${FILESDIR}/13_security_CVE-2013-6892.patch"
	"${FILESDIR}/30_CVE-2016-2511.patch"
	"${FILESDIR}/31_CVE-2016-1236.patch"
)

S="${WORKDIR}/${MY_P}"

src_install() {
	webapp_src_preinst

	DOCS=( changes.txt )
	HTML_DOCS=( doc/* )
	einstalldocs

	mv include/{dist,}config.php
	rm -rf license.txt changes.txt doc/

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_configfile "${MY_HTDOCSDIR}"/include/config.php
	webapp_configfile "${MY_HTDOCSDIR}"/wsvn.php

	webapp_serverowned "${MY_HTDOCSDIR}"/cache

	webapp_src_install
}
