# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils webapp

MY_PV=${PV/_/-}
MY_PN="phpMyAdmin"
MY_P="${MY_PN}-${MY_PV}-all-languages"

DESCRIPTION="Web-based administration for MySQL database in PHP"
HOMEPAGE="http://www.phpmyadmin.net/"
SRC_URI="https://files.phpmyadmin.net/${MY_PN}/${MY_PV}/${MY_P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 hppa ~ia64 ppc ppc64 sparc x86 ~x86-fbsd ~ppc-macos ~x64-macos ~x86-macos"
IUSE="setup"

RDEPEND="
	dev-lang/php[crypt,ctype,filter,json,session,unicode]
	|| (
		dev-lang/php[mysqli]
		dev-lang/php[mysql]
	)
	virtual/httpd-php:*
"

need_httpd_cgi

S="${WORKDIR}"/${MY_P}

pkg_setup() {
	webapp_pkg_setup
}

src_install() {
	webapp_src_preinst

	dodoc README RELEASE-DATE-${MY_PV} ChangeLog || die
	rm -f LICENSE README* RELEASE-DATE-${MY_PV}

	if ! use setup; then
		rm -rf setup || die "Cannot remove setup utility"
		elog "The phpMyAdmin setup utility has been removed."
		elog "It is a regular target of various exploits. If you need it, set USE=setup."
	else
		elog "You should consider disabling the setup USE flag"
		elog "to exclude the setup utility if you don't use it."
		elog "It regularly is the target of various exploits."
	fi

	insinto "${MY_HTDOCSDIR#${EPREFIX}}"
	doins -r .

	webapp_configfile "${MY_HTDOCSDIR#${EPREFIX}}"/libraries/config.default.php
	webapp_serverowned "${MY_HTDOCSDIR#${EPREFIX}}"/libraries/config.default.php

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en-3.1.txt
	webapp_src_install
}
