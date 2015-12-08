# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit webapp

DESCRIPTION="A CalDAV and CardDAV Server"
HOMEPAGE="http://davical.org/"
SRC_URI="https://gitlab.com/${PN}-project/${PN}/repository/archive.tar.gz?ref=r${PV} -> ${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=dev-php/awl-0.55
	sys-devel/gettext"
RDEPEND="app-admin/pwgen
	dev-lang/php:*[calendar,curl,pdo,postgres,xml]
	dev-perl/DBI
	dev-perl/DBD-Pg
	dev-perl/yaml
	>=dev-php/awl-0.55
	virtual/httpd-php"

S="${WORKDIR}/${PN}.git"

need_httpd

src_prepare() {
	epatch "${FILESDIR}/awl-locations.patch"
	epatch "${FILESDIR}/inc_path.patch"
}

src_compile() {
	emake built-po
}

src_install() {
	webapp_src_preinst

	dodoc INSTALL README debian/README.Debian \
		testing/README.regression_tests TODO debian/changelog

	einfo "Installing web files"
	insinto "${MY_HTDOCSDIR}"
	doins -r htdocs/* htdocs/.htaccess

	einfo "Installing main files and i18n"
	insinto "${MY_HOSTROOTDIR}/${PN}"
	doins -r inc locale
	rm "${D}/${MY_HOSTROOTDIR}/${PN}/inc/always.php.in" || die

	einfo "Installing sql files"
	insinto "${MY_SQLSCRIPTSDIR}"
	doins -r dba/*

	if use doc ; then
		einfo "Installing documentation"
		dohtml -r docs/api/ docs/website/
	fi

	insinto /etc/${PN}
	doins config/* "${FILESDIR}/vhost-example"

	webapp_postinst_txt en "${FILESDIR}/postinstall-en.txt"
	webapp_src_install

	fperms +x "${MY_SQLSCRIPTSDIR}/create-database.sh"
	fperms +x "${MY_SQLSCRIPTSDIR}/update-davical-database"
}
