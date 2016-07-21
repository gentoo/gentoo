# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Icinga Web 2 plugin for pnp4nagios"
HOMEPAGE="http://www.icinga.org/"
if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Icinga/icingaweb2-module-pnp.git"
else
	KEYWORDS="~amd64 ~x86"
	MY_PN="icingaweb2-module-pnp"
	SRC_URI="https://codeload.github.com/Icinga/${MY_PN}/tar.gz/v${PV} -> ${P}.tar.gz"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND=">=net-analyzer/icinga2-2.1.1
	>=www-apps/icingaweb2-2.0.0"
RDEPEND="${DEPEND}"

src_install() {
	insinto "/usr/share/icingaweb2/modules/pnp"
	doins -r "${S}"/*
}
