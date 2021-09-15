# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Data files for the cross-platform 3D realtime strategy game MegaGlest"
HOMEPAGE="https://www.megaglest.org/"
SRC_URI="https://github.com/MegaGlest/megaglest-data/releases/download/${PV}/${P}.tar.xz"
S="${WORKDIR}/megaglest-${PV}"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc"

src_configure() {
	local mycmakeargs=(
		-DMEGAGLEST_APPDATA_INSTALL_PATH="${EPREFIX}"/usr/share/metainfo #709450
	)

	cmake_src_configure
}

src_install() {
	local DOCS=( docs/{AUTHORS.data,CHANGELOG,README}.txt )
	use doc && local HTML_DOCS=( docs/glest_factions )

	cmake_src_install
}
