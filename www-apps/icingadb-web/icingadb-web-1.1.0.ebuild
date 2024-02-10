# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="UI for Icinga DB"
HOMEPAGE="https://icinga.com/docs/icinga-db-web/"
KEYWORDS="amd64"
SRC_URI="https://github.com/Icinga/icingadb-web/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	|| (
		dev-lang/php:8.1[curl,xml]
		dev-lang/php:8.2[curl,xml]
	)
	>=dev-libs/icinga-php-library-0.13
	>=dev-libs/icinga-php-thirdparty-0.12
	>=www-apps/icingaweb2-2.9.0
"

src_install() {
	insinto "/usr/share/icingaweb2/modules/icingadb/"
	doins -r "${S}"/*
}
