# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Libraries useful for Icinga Web 2"
HOMEPAGE="https://dev.icinga.org/projects/icingaweb2-module-incubator/"
KEYWORDS="amd64 x86"
MY_PN="icingaweb2-module-incubator"
SRC_URI="https://codeload.github.com/Icinga/${MY_PN}/tar.gz/v${PV} -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-2"
SLOT="0"

DEPEND=">=net-analyzer/icinga2-2.6.0
	>=www-apps/icingaweb2-2.6.0
	|| (
		dev-lang/php:7.3[curl]
		dev-lang/php:7.4[curl]
		dev-lang/php:8.0[curl]
	)"
RDEPEND="${DEPEND}"

src_install() {
	insinto "/usr/share/icingaweb2/modules/incubator/"
	doins -r "${S}"/*
}
