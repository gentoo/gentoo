# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit webapp

DESCRIPTION="A CalDAV and CardDAV Server"
HOMEPAGE="https://davical.org/"
SRC_URI="https://www.davical.org/downloads/${PN}_${PV}.orig.tar.xz -> ${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-php/awl-0.59
	sys-devel/gettext"
RDEPEND="app-admin/pwgen
	dev-lang/php:*[calendar,curl,pdo,postgres,xml]
	dev-perl/DBD-Pg
	dev-perl/DBI
	dev-perl/YAML
	>=dev-php/awl-0.59
	virtual/httpd-php"

need_httpd

PATCHES=( "${FILESDIR}/${P}-fix_php4_style_constructors.patch" )

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
	webapp_src_install

	fperms +x "${MY_SQLSCRIPTSDIR}/create-database.sh"
	fperms +x "${MY_SQLSCRIPTSDIR}/update-davical-database"
}
