# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Electronic Schematic and PCB design tools project templates"
HOMEPAGE="https://github.com/kicad/kicad-templates"
if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.com/kicad/libraries/${PN}.git"
	inherit autotools git-r3
	#EGIT_BRANCH=
else
	SRC_URI="https://gitlab.com/kicad/libraries/${PN}/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="CC-BY-SA-4.0"
SLOT="0"

RDEPEND=">=sci-electronics/kicad-5.1.0"
