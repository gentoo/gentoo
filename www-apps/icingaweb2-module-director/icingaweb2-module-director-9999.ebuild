# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Icinga Web 2 plugin for configuration"
HOMEPAGE="https://dev.icinga.org/projects/icingaweb2-module-director/"
if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Icinga/icingaweb2-module-director.git"
else
	KEYWORDS="~amd64 ~x86"
	MY_PN="icingaweb2-module-director"
	SRC_URI="https://codeload.github.com/Icinga/${MY_PN}/tar.gz/v${PV} -> ${P}.tar.gz"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND=">=net-analyzer/icinga2-2.4.3
	>=www-apps/icingaweb2-2.2.0
	|| (
		dev-lang/php:5.6[curl]
		dev-lang/php:7.0[curl]
	)"
RDEPEND="${DEPEND}"

src_install() {
	insinto "/usr/share/icingaweb2/modules/director/"
	doins -r "${S}"/*
}
