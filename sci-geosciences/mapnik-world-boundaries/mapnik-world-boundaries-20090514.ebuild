# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Mapnik World Boundaries"
HOMEPAGE="https://www.openstreetmap.org/"
SRC_URI="mirror://gentoo/world_boundaries-spherical-20090331.tgz
	mirror://gentoo/processed_p-20090514.zip"

LICENSE="CC-BY-SA-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"

src_prepare() {
	default
	mv coastlines/* world_boundaries/
}

src_install() {
	insinto /usr/share/mapnik
	doins -r world_boundaries
}
