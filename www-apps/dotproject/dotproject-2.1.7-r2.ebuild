# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

DESCRIPTION="dotProject is a PHP web-based project management framework"
HOMEPAGE="http://www.dotproject.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND="
	app-text/poppler[utils]
	dev-php/PEAR-Date
	virtual/httpd-php
"

need_httpd_cgi

PATCHES=(
	"${FILESDIR}"/${P}-pear-date.patch
)

src_install() {
	webapp_src_preinst

	dodoc ChangeLog README
	rm -r ChangeLog README lib/PEAR/Date.php lib/PEAR/Date || die

	mv includes/config{-dist,}.php || die

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_serverowned "${MY_HTDOCSDIR}"/includes/config.php
	webapp_serverowned "${MY_HTDOCSDIR}"/files{,/temp}
	webapp_serverowned "${MY_HTDOCSDIR}"/locales/en

	webapp_postinst_txt en "${FILESDIR}"/install-en.txt
	webapp_src_install
}
