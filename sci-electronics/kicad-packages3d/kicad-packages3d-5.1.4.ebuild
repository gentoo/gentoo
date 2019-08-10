# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs cmake-utils

DESCRIPTION="Electronic Schematic and PCB design tools 3D package libraries"
HOMEPAGE="https://kicad.github.io/packages3d/"
SRC_URI="https://github.com/KiCad/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="occ +oce"

REQUIRED_USE="|| ( occ oce )"

DEPEND=""
RDEPEND=">=sci-electronics/kicad-5.1.0[occ=,oce=]"

CHECKREQS_DISK_BUILD="9G"
S="${WORKDIR}/${P/3d/3D}"
