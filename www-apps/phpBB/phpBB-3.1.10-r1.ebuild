# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit webapp

DESCRIPTION="An open-source bulletin board package"
HOMEPAGE="https://www.phpbb.com/"
SRC_URI="https://download.phpbb.com/pub/release/${PV:0:3}/${PV}/${P}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm64 ~ppc ~sparc ~x86"
IUSE="ftp gd imagemagick mssql mysqli postgres sqlite xml zlib"

PHPV="5*:*"
RDEPEND="=virtual/httpd-php-${PHPV}
	=dev-lang/php-${PHPV}[ftp?,gd?,json,mssql?,mysqli?,postgres?,sqlite?,xml?,zlib?]
	imagemagick? ( virtual/imagemagick-tools )"

need_httpd_cgi

S="${WORKDIR}/${PN}${PV%%.*}"

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_serverowned "${MY_HTDOCSDIR}"/cache
	webapp_serverowned "${MY_HTDOCSDIR}"/files
	webapp_serverowned "${MY_HTDOCSDIR}"/images/avatars/upload
	webapp_serverowned "${MY_HTDOCSDIR}"/store
	webapp_serverowned "${MY_HTDOCSDIR}"/config.php
	webapp_configfile  "${MY_HTDOCSDIR}"/config.php

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install

	# phpBB needs docs together with the other files.
	dosym "${MY_HTDOCSDIR}"/docs /usr/share/doc/${PF}
}
