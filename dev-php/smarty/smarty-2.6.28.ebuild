# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/smarty/smarty-2.6.28.ebuild,v 1.10 2014/08/10 21:05:33 slyfox Exp $

EAPI=4

inherit eutils

KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"

MY_P="Smarty-${PV}"

DESCRIPTION="A template engine for PHP"
HOMEPAGE="http://www.smarty.net/"
SRC_URI="http://www.smarty.net/files/${MY_P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc"

DEPEND=""
RDEPEND=""
PDEPEND="doc? ( =dev-php/smarty-docs-2* )"

S="${WORKDIR}/${MY_P}"

DOCS="BUGS ChangeLog FAQ NEWS QUICK_START README RELEASE_NOTES TODO"

src_install() {
	insinto "/usr/share/php/${PN}"
	doins -r libs/*
	dodoc ${DOCS}
}

pkg_postinst() {
	elog "${PN} has been installed in /usr/share/php/${PN}/."
	elog "To use it in your scripts, either"
	elog "1. define('SMARTY_DIR', \"/usr/share/php/${PN}/\") in your scripts, or"
	elog "2. add '/usr/share/php/${PN}/' to the 'include_path' variable in your"
	elog "php.ini file under /etc/php/*-php5.x"
}
