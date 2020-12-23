# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_PN="megaglest"
DESCRIPTION="Data files for the cross-platform 3D realtime strategy game MegaGlest"
HOMEPAGE="http://www.megaglest.org/"
SRC_URI="https://github.com/MegaGlest/megaglest-data/releases/download/${PV}/megaglest-data-${PV}.tar.xz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DOCS=( docs/AUTHORS.data.txt docs/CHANGELOG.txt docs/README.txt )

S=${WORKDIR}/${MY_PN}-${PV}

src_install() {
	use doc && HTML_DOCS+=( docs/glest_factions/ )
	cmake_src_install
}
