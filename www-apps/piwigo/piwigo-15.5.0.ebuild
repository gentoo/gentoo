# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit webapp

DESCRIPTION="a photo gallery software for the web"
HOMEPAGE="http://piwigo.org/"
SRC_URI="http://piwigo.org/download/dlcounter.php?code=${PV} -> ${P}.zip"
S=${WORKDIR}/${PN}

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="+exif +gd imagemagick"

RDEPEND="
	imagemagick? ( virtual/imagemagick-tools )
	dev-lang/php[ctype,exif?,gd?,filter,iconv,json(+),mysqli]
	>=virtual/mysql-5.0
	virtual/httpd-php"
BDEPEND="app-arch/unzip"

REQUIRED_USE="|| ( gd imagemagick )"

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	# Local configuration, and parts that can be updated
	webapp_serverowned "${MY_HTDOCSDIR}"/_data
	webapp_serverowned -R "${MY_HTDOCSDIR}"/galleries
	webapp_serverowned -R "${MY_HTDOCSDIR}"/language
	webapp_serverowned -R "${MY_HTDOCSDIR}"/local
	webapp_serverowned -R "${MY_HTDOCSDIR}"/plugins
	webapp_serverowned -R "${MY_HTDOCSDIR}"/template-extension
	webapp_serverowned -R "${MY_HTDOCSDIR}"/themes
	webapp_serverowned "${MY_HTDOCSDIR}"/upload

	webapp_src_install
}
