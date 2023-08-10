# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit readme.gentoo-r1 webapp

DESCRIPTION="The multipurpose rss reader, live stream, mashup, aggregation web application"
HOMEPAGE="https://selfoss.aditu.de/"
SRC_URI="https://dl.cloudsmith.io/public/fossar/${PN}-git/raw/names/${PN}.zip/versions/2.20-cdc7f3e/${PN}-2.20-cdc7f3e.zip"
S="${WORKDIR}"/${PN}

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="app-arch/unzip"
RDEPEND="
	dev-lang/php[curl,gd]
	virtual/httpd-php
	|| (
		dev-db/mysql
		dev-db/postgresql
		dev-db/sqlite
	)
"

DOC_CONTENTS="Default selfoss config is installed as defaults.ini,
copy that config to config.ini and customize as you wish."

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

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
