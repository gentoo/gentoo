# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Electronic Schematic and PCB design tools footprint libraries"
HOMEPAGE="https://kicad.github.io/footprints/"
SRC_URI="https://github.com/KiCad/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=sci-electronics/kicad-5.1.0"
