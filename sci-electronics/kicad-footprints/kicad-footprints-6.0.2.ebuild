# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Electronic Schematic and PCB design tools footprint libraries"
HOMEPAGE="https://gitlab.com/kicad/libraries/kicad-footprints"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.com/kicad/libraries/kicad-footprints.git"
	inherit git-r3
else
	MY_PV="${PV/_rc/-rc}"
	MY_P="${PN}-${MY_PV}"
	SRC_URI="https://gitlab.com/kicad/libraries/${PN}/-/archive/${MY_PV}/${MY_P}.tar.gz -> ${P}.tar.gz"

	if [[ ${PV} != *_rc* ]] ; then
		KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
	fi

	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="CC-BY-SA-4.0"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=">=sci-electronics/kicad-6.0.0"

if [[ ${PV} == 9999 ]] ; then
#	 x11-misc-util/macros only required on live ebuilds
	BDEPEND+=" >=x11-misc/util-macros-1.18"
fi
