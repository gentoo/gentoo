# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Icinga Web 2 plugin for Graphite"
HOMEPAGE="https://www.icinga.com/docs/graphite/latest/"
if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Icinga/icingaweb2-module-graphite.git"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/Icinga/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND=">=net-analyzer/icinga2-2.4.0
	>=www-apps/icingaweb2-2.5.0"
RDEPEND="${DEPEND}"

src_install() {
	insinto "/usr/share/icingaweb2/modules/graphite/"
	doins -r "${S}"/*
}
