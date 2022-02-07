# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs cmake

DESCRIPTION="Electronic Schematic and PCB design tools 3D package libraries"
HOMEPAGE="https://kicad.github.io/packages3d/"
SRC_URI="https://gitlab.com/kicad/libraries/kicad-packages3D/-/archive/${PV}/kicad-packages3D-${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="+occ"

RDEPEND=">=sci-electronics/kicad-5.1.0[occ=]"

CHECKREQS_DISK_BUILD="11G"
S="${WORKDIR}/${P/3d/3D}"
