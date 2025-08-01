# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

DESCRIPTION="An open-source PHP-based bulletin board package"
HOMEPAGE="https://www.phpbb.com/"
SRC_URI="https://download.phpbb.com/pub/release/$(ver_cut 1-2)/${PV}/${P}.tar.bz2"
S="${WORKDIR}/${PN}${PV%%.*}"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~sparc ~x86"
IUSE="ftp gd mssql mysqli postgres sqlite zlib"
REQUIRED_USE="|| ( mssql mysqli postgres sqlite )"

PHP_RDEPEND="(
	virtual/httpd-php:@SLOT@
	dev-lang/php:@SLOT@[ftp?,gd?,json(+),mssql?,mysqli?,postgres?,sqlite?,xml,zlib?]
)"

RDEPEND="|| (
	${PHP_RDEPEND//@SLOT@/8.4}
	${PHP_RDEPEND//@SLOT@/8.3}
	${PHP_RDEPEND//@SLOT@/8.2}
)"

need_httpd_cgi

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_configfile  "${MY_HTDOCSDIR}"/config.php
	webapp_hook_script "${FILESDIR}"/permissions
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install

	# phpBB needs docs together with the other files.
	dosym ../webapps/${PN}/${SLOT}/htdocs/docs /usr/share/doc/${PF}
}

pkg_postinst() {
	einfo "phpBB needs a specific web server configuration. For Apache httpd, an"
	einfo "example configuration is provided via .htaccess files. For lighttpd and"
	einfo "NGINX, example configuration files can be found in the documentation."

	if use vhosts; then
		echo
		ewarn "When installing with webapp-config, specify a group that includes your"
		ewarn "PHP user with the -g option. It will default to the web server group"
		ewarn "when running webapp-config as root."
	fi
}
