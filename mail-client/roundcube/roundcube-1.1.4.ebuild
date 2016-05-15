# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit webapp

MY_PN=${PN}mail
MY_P=${MY_PN}-${PV/_/-}

DESCRIPTION="A browser-based multilingual IMAP client with an application-like user interface"
HOMEPAGE="http://roundcube.net"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.gz"

# roundcube is GPL-licensed, the rest of the licenses here are
# for bundled PEAR components, googiespell and utf8.class.php
LICENSE="GPL-3 BSD PHP-2.02 PHP-3 MIT public-domain"
KEYWORDS="amd64 arm ~hppa ppc ~ppc64 ~sparc x86"

IUSE="enigma ldap managesieve mysql postgres sqlite ssl spell"
REQUIRED_USE="|| ( mysql postgres sqlite )"

# this function only sets DEPEND so we need to include that in RDEPEND
need_httpd_cgi

RDEPEND="
	${DEPEND}
	>=dev-lang/php-5.3.7[crypt,filter,gd,iconv,json,ldap?,pdo,postgres?,session,sockets,sqlite?,ssl?,unicode,xml]
	>=dev-php/PEAR-Auth_SASL-1.0.6
	>=dev-php/PEAR-Mail_Mime-1.8.9
	>=dev-php/PEAR-Mail_mimeDecode-1.5.5
	>=dev-php/PEAR-Net_IDNA2-0.1.1
	>=dev-php/PEAR-Net_SMTP-1.6.2
	virtual/httpd-php
	enigma? ( >=dev-php/PEAR-Crypt_GPG-1.2.0 app-crypt/gnupg )
	ldap? ( >=dev-php/PEAR-Net_LDAP2-2.0.12 )
	managesieve? ( >=dev-php/PEAR-Net_Sieve-1.3.2 )
	mysql? ( || ( dev-lang/php[mysql] dev-lang/php[mysqli] ) )
	spell? ( dev-lang/php[curl,spell] )
"

S=${WORKDIR}/${MY_P}

src_install() {
	webapp_src_preinst
	dodoc CHANGELOG INSTALL README.md UPGRADING

	insinto "${MY_HTDOCSDIR}"
	doins -r [[:lower:]]* SQL
	doins .htaccess

	webapp_serverowned "${MY_HTDOCSDIR}"/logs
	webapp_serverowned "${MY_HTDOCSDIR}"/temp

	webapp_configfile "${MY_HTDOCSDIR}"/config/defaults.inc.php
	webapp_postupgrade_txt en "${FILESDIR}/POST-UPGRADE.txt"
	webapp_src_install
}

pkg_postinst() {
	webapp_pkg_postinst

	ewarn
	ewarn "When upgrading from <= 0.9, note that the old configuration files"
	ewarn "named main.inc.php and db.inc.php are deprecated and should be"
	ewarn "replaced with one single config.inc.php file."
	ewarn
	ewarn "Run the ./bin/update.sh script to convert those"
	ewarn "or manually merge the files."
	ewarn
	ewarn "The new config.inc.php should only contain options that"
	ewarn "differ from the ones listed in defaults.inc.php."
	ewarn
}
