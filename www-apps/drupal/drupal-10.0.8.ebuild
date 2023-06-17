# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

MY_PV=${PV:0:3}.0
MY_P=${P/_/-}
S="${WORKDIR}/${MY_P}"

DESCRIPTION="PHP-based open-source platform and content management system"
HOMEPAGE="https://www.drupal.org/"
SRC_URI="https://ftp.drupal.org/files/projects/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="+mysql postgres sqlite +uploadprogress"

# upstream supports php 8.1+, but dev-php/pecl-uploadprogress does not have 8.2
# limit php to 8.1 for now
RDEPEND="
	dev-lang/php:8.1[gd,hash(+),mysql?,pdo,postgres?,simplexml,sqlite?,xml]
	virtual/httpd-php
	uploadprogress? ( dev-php/pecl-uploadprogress[php_targets_php8-1] )
"

need_httpd_cgi

REQUIRED_USE="|| ( mysql postgres sqlite )"

src_install() {
	webapp_src_preinst

	local docs="LICENSE.txt README.md core/MAINTAINERS.txt core/INSTALL.txt core/CHANGELOG.txt \
		core/INSTALL.mysql.txt core/INSTALL.pgsql.txt core/INSTALL.sqlite.txt core/UPDATE.txt \
		core/USAGE.txt "

	dodoc ${docs}
	rm ${docs} core/COPYRIGHT.txt core/LICENSE.txt || die

	cp sites/default/{default.settings.php,settings.php} || die
	insinto "${MY_HTDOCSDIR}"
	doins -r .

	dodir "${MY_HTDOCSDIR}"/files
	webapp_serverowned "${MY_HTDOCSDIR}"/files

	webapp_configfile "${MY_HTDOCSDIR}"/sites/default/settings.php
	webapp_configfile "${MY_HTDOCSDIR}"/.htaccess

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt

	webapp_src_install
}

pkg_postinst() {
	echo
	ewarn "SECURITY NOTICE"
	ewarn "If you plan on using SSL on your Drupal site, please consult the postinstall information:"
	ewarn "\t# webapp-config --show-postinst ${PN} ${PV}"
	echo
	ewarn "If this is a new install, unless you want anyone with network access to your server to be"
	ewarn "able to run the setup, you'll have to configure your web server to limit access to it."
	echo
	ewarn "If you're doing a new drupal-10 install, you'll have to copy /sites/default/default.services.yml"
	ewarn "to /sites/default/services.yml and grant it write permissions to your web server."
	ewarn "Just follow the instructions of the drupal setup and be sure to resolve any permissions issue"
	ewarn "reported by the setup."
	echo
}
