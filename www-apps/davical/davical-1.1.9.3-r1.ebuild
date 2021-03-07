# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit optfeature webapp

DESCRIPTION="A CalDAV and CardDAV Server"
HOMEPAGE="https://www.davical.org/"
SRC_URI="https://www.davical.org/downloads/${PN}_${PV}.orig.tar.xz -> ${P}.tar.xz"

LICENSE="GPL-2 GPL-2+ GPL-3+ LGPL-2.1+ LGPL-3+"
KEYWORDS="~amd64 ~x86"

BDEPEND="sys-devel/gettext"

RDEPEND="app-admin/pwgen
	dev-lang/php[calendar,curl,iconv,imap,nls,pdo,postgres,xml]
	dev-perl/DBD-Pg
	dev-perl/DBI
	dev-perl/YAML
	>=dev-php/awl-0.61
	virtual/httpd-php"

PATCHES=( "${FILESDIR}/${P}-php8_compatibility.patch" )

need_httpd

S="${WORKDIR}"

src_compile() {
	emake built-locale
}

src_install() {
	webapp_src_preinst

	einstalldocs

	einfo "Installing web files"
	insinto "${MY_HTDOCSDIR}"
	doins -r htdocs/. htdocs/.htaccess

	einfo "Installing main files and i18n"
	insinto "${MY_HOSTROOTDIR}/${PN}"
	doins -r inc locale
	rm "${ED}/${MY_HOSTROOTDIR}/${PN}/inc/always.php.in" || die

	einfo "Installing sql files"
	insinto "${MY_SQLSCRIPTSDIR}"
	doins -r dba/.

	insinto /etc/${PN}
	doins -r config/. "${FILESDIR}/vhost-example"

	webapp_postinst_txt en "${FILESDIR}/postinstall-en.txt"
	webapp_postupgrade_txt en "${FILESDIR}/postupgrade-en.txt"
	webapp_src_install

	fperms +x "${MY_SQLSCRIPTSDIR}/create-database.sh"
	fperms +x "${MY_SQLSCRIPTSDIR}/update-davical-database"
}

pkg_postinst() {
	elog "If you are upgrading from a previous version of davical, don't forget to"
	elog "upgrade the database structure with"
	elog "       cd /usr/share/webapps/davical/${PVR}/sqlscripts/"
	elog "       ./update-davical-database -dbuser xxxxxxx -appuser xxxxxx"

	webapp_pkg_postinst

	elog ""
	elog "Optional runtime dependencies:"
	optfeature "LDAP authentication" dev-lang/php[ldap]
}
