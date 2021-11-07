# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs cmake

DESCRIPTION="Electronic Schematic and PCB design tools 3D package libraries"
HOMEPAGE="https://gitlab.com/kicad/libraries/kicad-packages3D"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.com/kicad/libraries/kicad-packages3D.git"
	inherit autotools git-r3
	# x11-misc-util/macros only required on live ebuilds
	LIVE_DEPEND=">=x11-misc/util-macros-1.18"
else
	SRC_URI="https://gitlab.com/kicad/code/${PN}/-/archive/${PV}/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
IUSE="+occ"
LICENSE="CC-BY-SA-4.0"
SLOT="0"

DEPEND=""
RDEPEND=">=sci-electronics/kicad-5.1.0[occ=]"

CHECKREQS_DISK_BUILD="11G"
#S="${WORKDIR}/${P/3d/3D}"
