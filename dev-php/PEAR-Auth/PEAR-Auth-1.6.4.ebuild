# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Auth/PEAR-Auth-1.6.4.ebuild,v 1.10 2014/08/10 20:43:49 slyfox Exp $

EAPI="4"
inherit php-pear-r1

DESCRIPTION="Provides methods for creating an authentication system using PHP"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ~ppc64 sparc x86"
IUSE="minimal"
RDEPEND="!minimal? ( >=dev-php/PEAR-Log-1.9.10
	>=dev-php/PEAR-File_Passwd-1.1.0
	>=dev-php/PEAR-Net_POP3-1.3.0
	>=dev-php/PEAR-DB-1.7.6-r1
	dev-php/PEAR-MDB
	>=dev-php/PEAR-MDB2-2.0.0_rc1
	>=dev-php/PEAR-Crypt_CHAP-1.0.0
	>=dev-php/PEAR-SOAP-0.9.0
	>=dev-php/PEAR-File_SMBPasswd-1.0.0
	>=dev-php/PEAR-HTTP_Client-1.1.0 )"

pkg_postinst() {
	if ! use minimal && ! has_version "dev-lang/php[imap,soap]" ; then
		elog "${PN} can optionally use php's imap and soap features."
		elog "If you want those, recompile dev-lang/php with these flags in USE."
	fi
}
