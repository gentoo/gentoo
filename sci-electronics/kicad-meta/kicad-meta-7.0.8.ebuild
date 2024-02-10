# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Electronic Schematic and PCB design tools (meta package)"
HOMEPAGE="http://www.kicad.org"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"

KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

IUSE="doc minimal"

RDEPEND="
	>=sci-electronics/kicad-${PV}
	>=sci-electronics/kicad-symbols-${PV}
	>=sci-electronics/kicad-footprints-${PV}
	doc? (
		>=app-doc/kicad-doc-${PV}
	)
	!minimal? (
		>=sci-electronics/kicad-packages3d-${PV}
		>=sci-electronics/kicad-templates-${PV}
	)
"
