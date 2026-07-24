# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit xdg

DESCRIPTION="Gentoo Linux Calamares installer configuration for LiveCD"
HOMEPAGE="https://github.com/StefanCristian/calamares-gentoo-livecd"
SRC_URI="https://github.com/StefanCristian/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>app-admin/calamares-3.3.14-r6[livecd(-)]
	app-admin/sudo
"

src_prepare() {
	default

	local baselayout_version
	baselayout_version=$(best_version sys-apps/baselayout)
	baselayout_version=${baselayout_version#*layout-}

	if [[ -n ${baselayout_version} ]]; then
		sed -i "s|GENTOO_VERSION|${baselayout_version}|g" "${WORKDIR}/${P}/artwork/branding.desc" || die
	fi
}
