# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Electronic Schematic and PCB design tools (meta package)"
HOMEPAGE="https://www.kicad.org"

LICENSE="metapackage"
SLOT="0"

KEYWORDS="amd64 ~riscv"

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
