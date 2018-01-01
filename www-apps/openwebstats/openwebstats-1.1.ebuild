# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit webapp

DESCRIPTION="PHP stats app that reads Apache logs and imports the data into a MySQL database"
HOMEPAGE="http://openwebstats.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-lang/php"

S=${WORKDIR}/${PN}

src_install() {
	webapp_src_preinst

	dodoc README

	## Main application
	cp -r . "${D}${MY_HTDOCSDIR}"
	cp "${FILESDIR}/config.php" "${D}${MY_HTDOCSDIR}/"

	## Docs installed, remove unnecessary files
	rm -f "${D}${MY_HTDOCSDIR}/README"
	rm -f "${D}${MY_HTDOCSDIR}/CHANGELOG"

	# Database creation
	webapp_sqlscript mysql "${D}${MY_HTDOCSDIR}/openwebstats.sql"

	# Postinstall instructions
	webapp_postinst_txt en "${FILESDIR}/postinstall-en.txt"

	webapp_src_install
}
