# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit webapp

MY_PN=${PN}mail
MY_PV=${PV/_/-}
MY_P=${MY_PN}-${MY_PV}

DESCRIPTION="A browser-based multilingual IMAP client with an application-like user interface"
HOMEPAGE="https://roundcube.net"

# roundcube is GPL-licensed, the rest of the licenses here are
# for bundled PEAR components, googiespell and utf8.class.php
LICENSE="GPL-3 BSD PHP-2.02 PHP-3 MIT public-domain"

IUSE="change-password enigma ldap mysql postgres sqlite ssl spell"
REQUIRED_USE="|| ( mysql postgres sqlite )"

# this function only sets DEPEND so we need to include that in RDEPEND
need_httpd_cgi

RDEPEND="
	${DEPEND}
	>=dev-lang/php-5.4.0[filter,gd,iconv,json(+),ldap?,pdo,postgres?,session,sqlite?,ssl?,unicode,xml]
	virtual/httpd-php
	change-password? (
		dev-lang/php[sockets]
	)
	enigma? (
		app-crypt/gnupg
	)
	mysql? (
		|| (
			dev-lang/php[mysql]
			dev-lang/php[mysqli]
		)
	)
	spell? ( dev-lang/php[curl,spell] )
"

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/roundcube/roundcubemail"
	EGIT_BRANCH="master"
	BDEPEND="${BDEPEND}
		app-arch/unzip
		dev-php/composer
		net-misc/curl"
else
	SRC_URI="https://github.com/${PN}/${MY_PN}/releases/download/${MY_PV}/${MY_P}-complete.tar.gz"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="amd64 arm ~hppa ppc ppc64 sparc x86"
fi

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		git-r3_src_unpack
		pushd "${S}" > /dev/null || die
		mv composer.json-dist composer.json || die
		composer install --no-dev || die
		./bin/install-jsdeps.sh || die
		popd > /dev/null || die
	else
		default
	fi
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
	webapp_postupgrade_txt en "${FILESDIR}/POST-UPGRADE_complete.txt"

	webapp_src_install
}

pkg_postinst() {
	webapp_pkg_postinst

	if [[ -n ${REPLACING_VERSIONS} ]]; then
		elog "You can review the post-upgrade instructions at:"
		elog "${EROOT}/usr/share/webapps/${PN}/${PV}/postupgrade-en.txt"
	fi
}
