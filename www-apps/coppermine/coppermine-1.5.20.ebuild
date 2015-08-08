# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit webapp versionator

DESCRIPTION="Web picture gallery written in PHP with a MySQL backend"
HOMEPAGE="http://coppermine.sourceforge.net/"
SRC_URI="mirror://sourceforge/eenemeenemuu.u/cpg${PV}.zip"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="virtual/httpd-php
	dev-lang/php[gd,mysql]"

S="${WORKDIR}"/$(version_format_string 'cpg$1$2x')

need_httpd_cgi

src_install() {
	webapp_src_preinst

	dodoc CHANGELOG.txt README.txt
	dohtml -r docs
	rm -rf CHANGELOG.txt README.txt COPYING docs/

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	dodir "${MY_HTDOCSDIR}"/albums/{userpics,edit}
	webapp_serverowned "${MY_HTDOCSDIR}"/albums{,/userpics,/edit}
	webapp_serverowned "${MY_HTDOCSDIR}"/include

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}
