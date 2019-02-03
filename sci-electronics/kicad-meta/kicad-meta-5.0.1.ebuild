# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Electronic Schematic and PCB design tools (meta package)"
HOMEPAGE="http://www.kicad-pcb.org"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc nls"

RDEPEND="
	>=sci-electronics/kicad-5.0.1
	>=sci-electronics/kicad-symbols-5.0.1
	>=sci-electronics/kicad-footprints-5.0.1
	>=sci-electronics/kicad-packages3d-5.0.1
	>=sci-electronics/kicad-templates-5.0.1
	doc? (
		>=app-doc/kicad-doc-5.0.1
	)
	nls? (
		>=sci-electronics/kicad-i18n-5.0.1
	)
"
