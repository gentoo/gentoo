# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="8"

MY_PN="calamares"
MY_P="${MY_PN}-${PV}"

inherit xdg

DESCRIPTION="Gentoo Linux Calamares installer configuration for LiveCD"
HOMEPAGE="https://github.com/StefanCristian/calamares-gentoo-livecd"
SRC_URI="https://github.com/StefanCristian/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
		mirror://gentoo/gentoo-artwork-livecd-2007.0.tar.bz2
		mirror://gentoo/gentoo-artwork-0.2.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="app-admin/${MY_PN}[livecd(-)]"

src_prepare() {
	default

	local baselayout_version
	baselayout_version=$(best_version sys-apps/baselayout)
	baselayout_version=${baselayout_version#*layout-}

	if [[ -n ${baselayout_version} ]]; then
		sed -i "s|GENTOO_VERSION|${baselayout_version}|g" "${WORKDIR}/${P}/artwork/branding.desc" || die
	fi
}
