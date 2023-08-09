# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs cmake

DESCRIPTION="Electronic Schematic and PCB design tools 3D package libraries"
HOMEPAGE="https://gitlab.com/kicad/libraries/kicad-packages3D"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.com/kicad/libraries/kicad-packages3D.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.com/kicad/libraries/kicad-packages3D/-/archive/${PV}/kicad-packages3D-${PV}.tar.bz2 -> ${P}.tar.bz2"
	S="${WORKDIR}/${PN/3d/3D}-${PV}"

	KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
fi

IUSE=""
LICENSE="CC-BY-SA-4.0"
SLOT="0"

RDEPEND=">=sci-electronics/kicad-7.0.0"

if [[ ${PV} == 9999 ]] ; then
	# x11-misc-util/macros only required on live ebuilds
	BDEPEND=">=x11-misc/util-macros-1.18"
fi

CHECKREQS_DISK_BUILD="11G"
