# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Electronic Schematic and PCB design tools (meta package)"
HOMEPAGE="http://www.kicad.org"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc minimal"

RDEPEND="
	>=sci-electronics/kicad-9999
	>=sci-electronics/kicad-symbols-9999
	>=sci-electronics/kicad-footprints-9999
	doc? (
		>=app-doc/kicad-doc-9999
	)
	!minimal? (
		>=sci-electronics/kicad-packages3d-9999
		>=sci-electronics/kicad-templates-9999
	)
"
