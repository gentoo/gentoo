# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Electronic Schematic and PCB design tools (meta package)"
HOMEPAGE="http://www.kicad.org"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="doc minimal nls"

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
	nls? (
		>=sci-electronics/kicad-i18n-${PV}
	)
"
