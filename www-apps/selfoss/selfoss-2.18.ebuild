# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit webapp

DESCRIPTION="The multipurpose rss reader, live stream, mashup, aggregation web application"
HOMEPAGE="https://selfoss.aditu.de/"
SRC_URI="https://github.com/SSilence/${PN}/releases/download/${PV}/${P}.zip"
S="${WORKDIR}"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"
RDEPEND="
	>=dev-lang/php-5.4.0[curl,gd]
	virtual/httpd-php
	|| (
		dev-db/mysql
		dev-db/postgresql
		dev-db/sqlite
	)
"

pkg_setup() {
	webapp_pkg_setup
}

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_serverowned -R "${MY_HTDOCSDIR}"/data
	webapp_serverowned -R "${MY_HTDOCSDIR}"/public
	webapp_configfile "${MY_HTDOCSDIR}"/.htaccess

	webapp_src_install
}

pkg_postinst() {
	elog "Default selfoss config is installed as defaults.ini;"
	elog "Copy that config to config.ini and customize as you wish."
}
