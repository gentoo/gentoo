# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/sitebar/sitebar-3.3.9-r2.ebuild,v 1.4 2012/10/17 03:00:18 phajdan.jr Exp $

EAPI=4

inherit base webapp

MY_P="SiteBar-${PV}"

DESCRIPTION="The Bookmark Server for Personal and Team Use"
HOMEPAGE="http://sitebar.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2
	plugins? (
		mirror://sourceforge/${PN}/SiteBarPluginIMAP_3.3.7_1.1.zip
		mirror://sourceforge/${PN}/SiteBarPluginLDAP_3.3.7_1.1.zip
		mirror://sourceforge/${PN}/SiteBarPluginMailGate_3.3.7_1.0.4.zip
		mirror://sourceforge/${PN}/SiteBarPluginMessenger_3.3.7_1.2.zip
		mirror://sourceforge/${PN}/SiteBarPluginXBELSync_3.3.7_1.1.zip
	)"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
IUSE="plugins"

DEPEND="virtual/httpd-php"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/inc_writer.inc.php.diff" )  # PHP 5.3 patch
DOCS=( readme.txt doc/history.txt doc/install.txt doc/troubleshooting.txt )

src_install() {
	webapp_src_preinst
	base_src_install_docs
	cp -R . "${D}/${MY_HTDOCSDIR}"
	use plugins && cp -R "${WORKDIR}/plugins/." "${D}/${MY_HTDOCSDIR}/plugins/."
	rm -rf "${D}/${MY_HTDOCSDIR}/doc" "${D}/${MY_HTDOCSDIR}/readme.txt"

	webapp_serverowned "${MY_HTDOCSDIR}/inc"
	webapp_postinst_txt en "${FILESDIR}/postinstall-en.txt"

	webapp_src_install
}
