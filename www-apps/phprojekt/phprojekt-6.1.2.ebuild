# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/phprojekt/phprojekt-6.1.2.ebuild,v 1.4 2012/10/18 17:59:50 blueness Exp $

EAPI=4

inherit vcs-snapshot webapp

MY_PN="PHProjekt"

DESCRIPTION="Project management and coordination system"
HOMEPAGE="http://www.phprojekt.com/"
SRC_URI="https://github.com/Mayflower/${MY_PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ppc x86"
IUSE="postgres mysql"

RDEPEND="virtual/httpd-php
	dev-lang/php[gd,imap,mysql?,pdo,postgres?,session,zlib]"

# need at least one option for a database
REQUIRED_USE="|| ( mysql postgres )"

src_install() {
	webapp_src_preinst

	dodoc phprojekt/INSTALL phprojekt/UPDATE phprojekt/README
	dodoc phprojekt/configuration.php-dist

	cp -R phprojekt/* "${D}/${MY_HTDOCSDIR}"
	cp phprojekt/.htaccess "${D}/${MY_HTDOCSDIR}"

	webapp_serverowned "${MY_HTDOCSDIR}"

	dodir "${MY_HOSTROOTDIR}/phprojekt_private"
	webapp_serverowned "${MY_HOSTROOTDIR}/phprojekt_private"

	webapp_postinst_txt en "${FILESDIR}"/postinstall-6-en.txt
	webapp_src_install
}
