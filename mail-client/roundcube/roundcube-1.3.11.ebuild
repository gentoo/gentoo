# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit webapp

MY_PN=${PN}mail
MY_P=${MY_PN}-${PV}

DESCRIPTION="A browser-based multilingual IMAP client with an application-like user interface"
HOMEPAGE="https://roundcube.net"
SRC_URI="https://github.com/${PN}/${MY_PN}/releases/download/${PV}/${MY_P}-complete.tar.gz"

# roundcube is GPL-licensed, the rest of the licenses here are
# for bundled PEAR components, googiespell and utf8.class.php
LICENSE="GPL-3 BSD PHP-2.02 PHP-3 MIT public-domain"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 sparc x86"

IUSE="change-password enigma ldap managesieve mysql postgres sqlite ssl spell"
REQUIRED_USE="|| ( mysql postgres sqlite )"

# this function only sets DEPEND so we need to include that in RDEPEND
need_httpd_cgi

# :TODO: Support "endriod/qrcode: ~1.6.5" dep (ebuild needed)
RDEPEND="
	${DEPEND}
	>=dev-lang/php-5.4.0[filter,gd,iconv,json,ldap?,pdo,postgres?,session,sqlite?,ssl?,unicode,xml]
	>=dev-php/PEAR-Auth_SASL-1.1.0
	>=dev-php/PEAR-Mail_Mime-1.10.0
	>=dev-php/PEAR-Mail_mimeDecode-1.5.5
	>=dev-php/PEAR-Net_IDNA2-0.2.0
	>=dev-php/PEAR-Net_SMTP-1.7.1
	virtual/httpd-php
	change-password? (
		>=dev-php/PEAR-Net_Socket-1.2.1
		dev-lang/php[sockets]
	)
	enigma? (
		>=dev-php/PEAR-Crypt_GPG-1.6.0
		app-crypt/gnupg
	)
	ldap? (
		>=dev-php/PEAR-Net_LDAP2-2.2.0
		dev-php/PEAR-Net_LDAP3
	)
	managesieve? ( >=dev-php/PEAR-Net_Sieve-1.4.0 )
	mysql? (
		|| (
			dev-lang/php[mysql]
			dev-lang/php[mysqli]
		)
	)
	spell? ( dev-lang/php[curl,spell] )
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	# Redundant. (Bug #644896)
	rm -r vendor/pear || die

	# Remove references to PEAR. (Bug #650910)
	cp "${FILESDIR}"/roundcube-1.3.7-pear-removed-installed.json \
		vendor/composer/installed.json \
		|| die
}

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

	if [[ -n ${REPLACING_VERSIONS} ]]; then
		elog "You can review the post-upgrade instructions at:"
		elog "${EROOT}/usr/share/webapps/${PN}/${PV}/postupgrade-en.txt"
	fi
}
